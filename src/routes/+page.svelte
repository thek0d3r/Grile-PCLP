<script>
    import Flashcard from './Flashcard.svelte';
    import ProgressBar from './ProgressBar.svelte';
    import FinishScreen from './FinishScreen.svelte';

    import { onMount } from 'svelte';

    let flashcards = [];
    
    onMount(async () => {
        try {
            const jsonData = await import('$lib/q.json');
            flashcards = jsonData.default;
            flashcards = shuffle(flashcards);
        } catch (error) {
            console.error('Error importing JSON:', error);
        }
    });

    $: if (flashcards && flashcards.length > 0) {
        flashcards = shuffle(flashcards);
    }

    let currentCardIndex = 0;
    let isCorrect = null;
    let selectedAnswer = [];
    let selectedCheckboxValues = {};
    let correctAns = 0;
    let grade = 0;
    let learnMode = false;
    let submitted = false;

    let submitButton;
    let skipButton;

    function nextCard() {
        isCorrect = null;
        currentCardIndex += 1;
        selectedAnswer = [];
        selectedCheckboxValues = {};
        submitted = false;

        skipButton.blur();
    }
  
    function validateAnswer() {
        submitButton.blur();
        
        if (selectedAnswer.length === 0) return;

        submitted = true;

        const currentCard = flashcards[currentCardIndex];
        isCorrect = arraysEqual(selectedAnswer, currentCard.correct);

        if (isCorrect) correctAns += 1;

        if(!learnMode) {
            setTimeout(() => {
                nextCard();
            }, 500);
        }
    }

    function shuffle(array) {
        console.log(array[0]);
        let currentIndex = array.length, randomIndex;

        while (currentIndex > 0) {

            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex--;

            [array[currentIndex], array[randomIndex]] = [
            array[randomIndex], array[currentIndex]];
        }

        console.log(array[0]);

        return array;
    }

    function arraysEqual(arr1, arr2) {
        if (arr1.length !== arr2.length) return false;

        const sortedArr1 = arr1.slice().sort();
        const sortedArr2 = arr2.slice().sort();

        return sortedArr1.every((value, index) => value === sortedArr2[index]);
    }


    function handleChange(event) {
        const value = event.target.value;

        if (selectedAnswer.includes(value)) {
            selectedAnswer = selectedAnswer.filter(ans => ans !== value);
            selectedCheckboxValues[value] = false;
        } else {
            selectedAnswer = [...selectedAnswer, value];
            selectedCheckboxValues[value] = true;
        }
    }
  
    function handleKeypress(event) {
        if (event.key === "Enter") {
            validateAnswer();
        }
    }

    function restart() {
        currentCardIndex = 0;
        correctAns = 0;
        isCorrect = null;
        selectedAnswer = [];
        selectedCheckboxValues = {};
        shuffle(flashcards);
    }
  
    $: progressPercentage = ((currentCardIndex) / 60) * 100;
    $: grade = (correctAns * 10 / 60).toFixed(2);

  </script>
  
  <main class="container-fluid" style="position: relative; width: 100vw; min-height: 100vh;">
    <div class="row">
        <h1>Examen grilă de antrenament PCLP</h1>
    </div>
  
    <br />
    <br />


    <div class="row">
        <div class="container">
            <ProgressBar progressPercentage={progressPercentage}></ProgressBar>
        </div>
    </div>
  
    <br />

    {#if flashcards.length > 0}
        <div class="row">
            {#if currentCardIndex != 60}
            <div class="container">
                <Flashcard 
                    flashcards={flashcards} 
                    currentCardIndex={currentCardIndex} 
                    selectedCheckboxValues={selectedCheckboxValues} 
                    handleChange={handleChange} 
                    handleKeypress={handleKeypress}>
                </Flashcard>
            </div>
            {:else}
                <FinishScreen grade={grade} restart={restart} correctAns={correctAns}></FinishScreen>
            {/if}
        </div>
        <div class="row">
            <div class="controls">
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" id="flexSwitchCheckDefault" bind:checked={learnMode}> 
                    <label class="form-check-label" for="flexSwitchCheckDefault">Modul de învățare</label>
                </div>
                <br />
                <button type="button" class="btn" on:click={!submitted ? validateAnswer : nextCard} class:btn-outline-primary={!submitted || !learnMode} class:btn-outline-success={submitted && learnMode} bind:this={submitButton}>{!learnMode || !submitted ? "Trimite" : "Următoarea întrebare"}</button>
                {#if !learnMode}
                    <button type="button" class="btn btn-outline-danger" on:click={nextCard} bind:this={skipButton}>Sari peste</button>
                {/if}
            </div>
        </div>
        <div class="row">
            {#if isCorrect === true}
                <p class="result correct">Correct!</p>
            {:else if isCorrect === false}
                <p class="result incorrect">Incorrect!</p>
                {#if learnMode === true}
                    <p class="correct">Răspunsul corect este: <br /> {flashcards[currentCardIndex].correct.join(', ')}</p>
                {/if}
            {/if}
        </div>
        {#if currentCardIndex == 0}
        <div class="row">
            <div class="disclaimer">
                <p>P.S. Dacă sari peste o întrebare, se consideră că ai răspuns greșit! Așa că nu le ocoli! Relaxează-te și ia-ți timpul necesar, nu e grabă 🙂</p>
            </div>
        </div>
        {/if}
    {:else}
        <p>Se incarcă întrebările...</p>
    {/if}
</main>