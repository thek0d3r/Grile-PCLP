<script>

    export let grade;
    export let restart;
    export let correctAns;

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

</script>

<div class="row">
    <div class="title">
        <h1>Finished!</h1>
    </div>    
</div>

<div class="row">
    <h3 class:red={grade < 5} class:green={grade >= 5}>Nota: {grade}</h3>
    <p>Correct: {correctAns}</p>
    <p>Total: 60</p>
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

