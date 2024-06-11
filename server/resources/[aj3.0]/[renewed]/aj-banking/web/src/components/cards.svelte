<script lang="ts">
    import { loading, notify, cardsDetail, orderDetail } from '../store/stores';
    import { fetchNui } from '../utils/fetchNui';

    function CloseCards(){
        cardsDetail.update(() => ({
            status : false,
            cards: []
        }));
    }
    function formatCardNumber(input: { match: (arg0: RegExp) => any[]; }) {

        let formatted = input.match(/.{1,4}/g)?.join(' ') || '';
        return formatted
    }
    function UpdateCard(id: any){
        CloseCards();
        loading.set(true);
        fetchNui('UpdateCard', {id:id}).then(retval =>{
            if (retval !== '' && retval !== true){
                notify.set(retval);
                setTimeout(() => {
                    notify.set("");
                }, 3500);
            }
            setTimeout(() => {
                loading.set(false);
            }, 1000);
        })
    }
    function DeleteCard(id: any,limit: any,maxlimit: any){
        console.log(id);
        // if (limit >= maxlimit){
            CloseCards();
            loading.set(true);
            fetchNui('DeleteCard', {id:id}).then(retval =>{
                if (retval !== '' && retval !== true){
                    notify.set(retval);
                    setTimeout(() => {
                        notify.set("");
                    }, 3500);
                }
                setTimeout(() => {
                    loading.set(false);
                }, 1000);
            })
        // } else {
        //     notify.set("Try Again letter when card usage is 0%");
        //     setTimeout(() => {
        //         notify.set("");
        //     }, 3500);
        // }
        
    }
    function handleordercard(){
        CloseCards()
        orderDetail.update(() => ({ status: true, pin:1111 }));
    }
    const  formatMoney = (amount: any) => {
        let formattedAmount = amount.toString();
        const parts = formattedAmount.split('.');
        let integerPart = parts[0];
        const decimalPart = parts.length > 1 ? '.' + parts[1] : '';
        integerPart = integerPart.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        return integerPart + decimalPart;
    }
</script>

<section class="popup-container">
    <section class="popup-content scroller2">
            <button type="button" class="btn btn-red" on:click={CloseCards}>Close</button>
            {#if $cardsDetail.cards.length > 0}
                <h2>Your Cards</h2>
                <div class="form-row ">
                    <div class="btns-group2">
                            {#each $cardsDetail.cards as car}
                                <div class="btns-group dev">Card Number: {formatCardNumber(car.card)}
                                    {#if car.blocked == 0}
                                        <button type="button" class="btn btn-orange" style="margin-top: 1.5vh;" on:click={() => UpdateCard(car.id)}>Block Card</button>
                                    {:else}
                                        <button type="button" class="btn btn-green" style="margin-top: 1.5vh;" on:click={() => UpdateCard(car.id)}>Unblock Card</button>
                                    {/if}
                                    <button type="button" class="btn btn-red" on:click={() => DeleteCard(car.id, car.limit, car.maxlimit)}>Delete Card</button>
                                </div>
                            {/each}
                        
                    </div>
                </div>
            {:else}
                <h2>It seems like you don't have a card order 1 now</h2>
                <div class="btns-group">
                    <button type="button" class="btn btn-green" on:click={handleordercard}>Order Now</button>
                </div>
            {/if}
    </section>
</section>

<style>
    /* .btns-group2 > :first-child {
    grid-column: 1 / -1;
  } */
  .btns-group2 {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-gap: 0.5rem;
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
        max-width: 75rem;
        width: 100%;
        height: 50%;
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
        border-radius: 5px;
        background-color: transparent;
        border: none;
        padding: 1.4rem;
        margin-bottom: 2rem;
        background-color: rgba(0,238,255,0.1);
        color: #fff; 
    }

    .form-row .dev2 {
        width: 100%;
        background-color: transparent;
        margin-top: 2rem;
        margin-bottom: 2rem;
        color: #fff; 
    }
</style>