<script lang="ts">
    import { loading, notify, itemsDetails, pinDetails } from '../store/stores';
    function CloseCards(){
        itemsDetails.update(() => ({ status: false, items:[] }));
    }
    function formatCardNumber(input: { match: (arg0: RegExp) => any[]; }) {

        let formatted = input.match(/.{1,4}/g)?.join(' ') || '';
        return formatted
    }
    function handlecard(cardNumber: string){
        CloseCards()
        pinDetails.update(() => ({ status: true, cardNumber:cardNumber }));
    }
</script>

<section class="popup-container">
    <section class="popup-content scroller2">
            <h2>Available Cards</h2>
            {#if $itemsDetails.items.length > 0}
                {#each $itemsDetails.items as item}
                    <div class="form-row ">
                        <div class="btns-group">
                            <div class="btns-group2 dev">Card Number: {formatCardNumber(item.info.Card_number)}
                                <div class="">Holder: {item.info.name}</div>
                                <button type="button" class="btn btn-grey" on:click={() => handlecard(item.info.Card_number)}>Use Card</button>
                            </div>
                        </div>
                    </div>
                {/each}
            {:else}
                <h2>No Card Found :( </h2>
            {/if}
    </section>
</section>

<style>
    .btns-group2 > :last-child {
        grid-column: 1 / -1;
    }
  .btns-group2 {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-gap: 1.5rem;
  }
    .popup-container {
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        right: 0;
        background-color: transparent;

        display: flex;
        align-items: center;
        justify-content: center;
    }

    .popup-content {
        max-width: 55rem;
        width: 100%;
        height: 80%;
        background-color: #000;
        border-radius: 0.5vh;
        border: 4px solid rgb(0,238,255);
        box-shadow: 0 0 2.5vh rgb(0,238,255);
        padding: 2rem;
        overflow-y: scroll;
    }

    h2 {
        margin-bottom: 3rem;
        text-align: center;
        font-size: 2rem;
    }

    .form-row {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
        color: #F3F4F5;
        margin-bottom: 2rem;
    }
    .form-row div {
        font-size: 1.4rem;
        color: inherit;
    }

    .form-row .dev {
        width: 100%;
        background-color: transparent;
        border: none;
        padding: 0.9rem;
        margin-bottom: 2rem;
        background-color: #000;
        border-radius: 0.5vh;
        border: 4px solid rgb(0, 133, 143);
        box-shadow: 0 0 2.5vh rgb(0,238,255);
        color: #fff; 
    }
</style>