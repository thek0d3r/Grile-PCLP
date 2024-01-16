<script>

export let progressPercentage;

</script>

<div class="progress">
    <div class="progress-bar" role="progressbar" style="width: {progressPercentage}%;" aria-valuenow="{progressPercentage}" aria-valuemin="0" aria-valuemax="100">{Math.floor(progressPercentage)}%</div>
</div>

