<script>
    import flashcards from '$lib/q.json';

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

    let currentCardIndex = 0;
    let isCorrect = null;
    let selectedAnswer = [];
    let selectedCheckboxValues = {};
    let correctAns = 0;
    let grade = 0;

    shuffle(flashcards);
  
    function nextCard() {
        isCorrect = null;
        currentCardIndex += 1;
        selectedAnswer = [];
        selectedCheckboxValues = {};
    }

    function shuffle(array) {
        let currentIndex = array.length,  randomIndex;

        while (currentIndex > 0) {

            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex--;

            [array[currentIndex], array[randomIndex]] = [
            array[randomIndex], array[currentIndex]];
        }

        return array;
    }
  
    function validateAnswer() {
        if (selectedAnswer == []) return;

        const currentCard = flashcards[currentCardIndex];
        isCorrect = arraysEqual(selectedAnswer, currentCard.correct);

        if (isCorrect) correctAns += 1;

        setTimeout(() => {
            nextCard();
        }, 500);
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
        } else {
            selectedAnswer = [...selectedAnswer, value];
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
  
    $: progressPercentage = ((currentCardIndex) / flashcards.length) * 100;
    $: grade = (correctAns * 10 / flashcards.length).toFixed(2);

  </script>
  
  <main class="container-fluid" style="position: relative; width: 100vw; height: 100vh">
    <div class="row">
        <h1>Examen grila de antrenament PCLP</h1>
    </div>
  
    <br />
    <br />


    <div class="row">
        <div class="container">
            <div class="progress">
                <div class="progress-bar" role="progressbar" style="width: {progressPercentage}%;" aria-valuenow="{progressPercentage}" aria-valuemin="0" aria-valuemax="100">{Math.floor(progressPercentage)}%</div>
            </div>
        </div>
    </div>
  
    <br />

    <div class="row">
        {#if currentCardIndex != flashcards.length}
        <div class="container">
            <div class="flashcard">
                <div class="question">{@html flashcards[currentCardIndex].question}</div>
                {#each flashcards[currentCardIndex].ansList as ans}
                    <div class="form-check" style="display: flex; align-items: center; justify-content: center;">
                        <input class="form-check-input" type="checkbox" id={ans} value={ans} on:change={handleChange} on:keypress={handleKeypress} bind:checked={selectedCheckboxValues[ans]}/>
                        <label class="form-check-label" style="margin-left: 5px" for={ans}>{@html ans}</label>
                    </div>
                {/each}
            </div>
        </div>
    
        <div class="controls">
            <button type="button" class="btn btn-outline-primary" on:click={validateAnswer}>Trimite</button>
            <button type="button" class="btn btn-outline-danger" on:click={nextCard}>Sari peste</button>
        </div>

        {#if isCorrect === true}
            <p class="result correct">Correct!</p>
        {:else if isCorrect === false}
            <p class="result incorrect">Incorrect!</p>
        {/if}
  
        <div class="disclaimer">
            <p>NOTE: Skipping a question will render the answer incorrect! So, don't skip them! Take your time 🙂</p>
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
  </main>
  
  <style>
    main {
        text-align: center;
    }
  
    .flashcard {
        border: 1px solid #ccc;
        background-color: #f9f9f9;
    }
  
    .question {
        font-size: 1.5rem;
        font-weight: bold;
        margin-bottom: 1rem;
        white-space: pre-line;
    }
  
    .green {
        color: green;
    }

    .red {
        color: red;
    }

    .user-answer {
        display: flex;
        justify-content: center;
        margin-top: 1rem;
    }
  
    .result {
        margin-top: 1rem;
        font-weight: bold;
    }
  
    .correct {
        color: green;
    }
  
    .incorrect {
        color: red;
    }
  
    .controls {
        margin-top: 1rem;
    }
  
    .disclaimer {
        text-align: center;
        font-size: 12px;

        position: absolute;
        bottom: 5px;
    }

    .title {
        text-align: center;
        font-size: large;
    }

    .final-msg {
        font-size: large;
    }
  </style>
  