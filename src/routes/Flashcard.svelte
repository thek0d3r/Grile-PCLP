<script>
    export let flashcards;
    export let currentCardIndex;
    export let selectedCheckboxValues;
    export let handleChange;
    export let handleKeypress;
</script>

<div class="flashcard col-xl-6 offset-xl-3">
    <div class="col-xl-6 offset-xl-3">
        <div class="question">{flashcards[currentCardIndex].question}</div>
        {#each flashcards[currentCardIndex].ansList as ans}
            <div class="form-check" style="display: flex; align-items: center; justify-content: center;">
                <input class="form-check-input" type="checkbox" id={ans} value={ans} on:change={handleChange} on:keypress={handleKeypress} bind:checked={selectedCheckboxValues[ans]}/>
                <label class="form-check-label" style="margin-left: 5px" for={ans}>{@html ans}</label>
            </div>
        {/each}
    </div>
</div>

