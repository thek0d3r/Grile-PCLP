<script>
    import Flashcard from './Flashcard.svelte';
    import ProgressBar from './ProgressBar.svelte';

    import { onMount } from 'svelte';

    let finalMsgBad = [
        "Nu a fost să fie frate! Ce să îi faci? 😐",
        "Mai bagă o fisă! 🪙",
        "De la lag! 🖥️",
        "Nu băga la păcănele perioada asta 🎰"
    ];
    
    let finalMsgGood = [
        "Felicitări! Le-ai nimerit! 👏",
        "Ne vedem în semestrul următor 🎓",
        "Ai prins comp-ul bun 🖥️",
        "Poți să bagi liniștit la păcănele 🎰"
    ];

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

    let submitButton;
    let skipButton;

    function nextCard() {
        isCorrect = null;
        currentCardIndex += 1;
        selectedAnswer = [];
        selectedCheckboxValues = {};

        skipButton.blur();
    }
  
    function validateAnswer() {
        submitButton.blur();
        
        if (selectedAnswer.length === 0) return;

        const currentCard = flashcards[currentCardIndex];
        isCorrect = arraysEqual(selectedAnswer, currentCard.correct);

        if (isCorrect) correctAns += 1;

        setTimeout(() => {
            nextCard();
        }, 500);
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
                    handleKeypress={handleKeypress}></Flashcard>
            </div>
        
            <div class="controls">
                <button type="button" class="btn btn-outline-primary" on:click={validateAnswer} bind:this={submitButton}>Trimite</button>
                <button type="button" class="btn btn-outline-danger" on:click={nextCard} bind:this={skipButton}>Sari peste</button>
            </div>

            {#if isCorrect === true}
                <p class="result correct">Correct!</p>
            {:else if isCorrect === false}
                <p class="result incorrect">Incorrect!</p>
            {/if}
    
            <div class="disclaimer">
                <p>P.S. Dacă sari peste o întrebare, se consideră că ai răspuns greșit! Așa că nu le ocoli! Relaxează-te și ia-ți timpul necesar, nu e grabă 🙂</p>
            </div>
            {:else}
                <div class="row">
                    <div class="title">
                        <h1>Finished!</h1>
                    </div>    
                </div>

                <div class="row">
                    <h3 class:red={grade < 5} class:green={grade >= 5}>Nota: {(correctAns * 10 / flashcards.length).toFixed(2)}</h3>
                    <p>Correct: {correctAns}</p>
                    <p>Total: {flashcards.length}</p>
                </div>

                {#if grade < 5}
                    <div class="row">
                        <p class="final-msg">{finalMsgBad[Math.floor(Math.random() * 3)]}</p>
                    </div>
                {:else}
                    <div class="row">
                        <p class="final-msg">{finalMsgGood[Math.floor(Math.random() * 3)]}</p>
                    </div>
                {/if}

                <div class="row">
                    <div class="container">
                        <button type="button" on:click={restart} class="btn btn-outline-info">Restart</button>
                    </div>
                </div>
            {/if}
        </div>
    {:else}
        <p>Se incarcă întrebările...</p>
    {/if}
</main>