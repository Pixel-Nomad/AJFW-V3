<script lang="ts">
    import { accounts, activeAccount, translations, atm, notify, orderDetail, cardsDetail, loading} from "../../store/stores";
    import AccountTransactionItem from "./AccountTransactionItem.svelte";
    import { convertToCSV } from "../../utils/convertToCSV";
    import { setClipboard } from "../../utils/setClipboad";
    import { fetchNui } from "../../utils/fetchNui";
    let transSearch = '';
    $: account = $accounts.find((accountItem: any) => $activeAccount === accountItem.id);

    function handleClickExportData() {
        if (account == null) console.log("No account selected");
        if (account.transactions.length === 0) {
            notify.set("No transactions to export!");
            setTimeout(() => {
                notify.set("");
            }, 3500);
            return;
        }
        const csv = convertToCSV(account.transactions);
        setClipboard(csv);
        notify.set("Data copied to clipboard!");
        setTimeout(() => {
            notify.set("");
        }, 3500);
    }
    let isAtm: boolean = false;
    atm.subscribe((usingAtm: boolean) => {
        isAtm = usingAtm;
    });
    function handleOrderCard(){
        orderDetail.update(() => ({ status: true, pin:1111 }));
    }
    function handleCardDetail(){
        fetchNui('GetCards',{}).then(retData => {
            loading.set(true);
            if (retData) {
                cardsDetail.update(() => ({ status: true, cards: retData }));
            }else{
                cardsDetail.update(() => ({ status: true, cards: [] }));
            }
            loading.set(false);
        })
    }
</script>

<section class="transactions-container">
    <h3 class="heading">
        <span>{$translations.transactions}</span>

        <div>
            <img src="./img/bank.png" alt="bang icon" />
            <span>{$translations.bank_name}</span>
        </div>
    </h3>

    <input type="text" class="transactions-search" placeholder={$translations.trans_search} bind:value={transSearch}>
    <section class="scroller">
        {#if account}
            {#if account.transactions.filter(item => item.message.toLowerCase().includes(transSearch.toLowerCase()) || item.trans_id.toLowerCase().includes(transSearch.toLowerCase()) || item.receiver.toLowerCase().includes(transSearch.toLowerCase())).length > 0}
                {#each account.transactions.filter(item => item.message.toLowerCase().includes(transSearch.toLowerCase()) || item.trans_id.toLowerCase().includes(transSearch.toLowerCase()) || item.receiver.toLowerCase().includes(transSearch.toLowerCase())) as transaction (transaction.trans_id)}
                    <AccountTransactionItem {transaction}/>
                {/each}
            {:else}
                <h3 style="text-align: left; color: #F3F4F5; margin-top: 1rem;">{$translations.trans_not_found}</h3>
            {/if}
        {:else}
            {$translations.select_account}
        {/if}
    </section>
    {#if !isAtm}
        <div class="export-data">
            <button disabled  class="btn btn-grey" style="display: flex; align-items: center; justify-content: center; gap: 1rem; margin-right: 3.5vh;" on:click|preventDefault={handleCardDetail}><i class="fa-solid fa-file-export fa-fw" />
                Your Card
            </button>
            <button disabled class="btn btn-grey" style="display: flex; align-items: center; justify-content: center; gap: 1rem; margin-right: 3.5vh;" on:click|preventDefault={handleOrderCard}><i class="fa-solid fa-file-export fa-fw" />
                Order Card
            </button>
            <button disabled class="btn btn-grey" style="display: flex; align-items: center; justify-content: center; gap: 1rem" on:click|preventDefault={handleClickExportData}><i class="fa-solid fa-file-export fa-fw" />
                {$translations.export_data}
            </button>
        </div>
    {:else}
        <div class="export-data">
            <button disabled class="btn btn-grey" style="display: flex; align-items: center; justify-content: center; gap: 1rem; margin-right: 3.5vh;" on:click|preventDefault={handleCardDetail}><i class="fa-solid fa-file-export fa-fw" />
                Your Cards
            </button>
            <button disabled class="btn btn-grey" style="display: flex; align-items: center; justify-content: center; gap: 1rem; margin-right: 3.5vh;" on:click|preventDefault={handleOrderCard}><i class="fa-solid fa-file-export fa-fw" />
                Order Card
            </button>
            <button disabled class="btn btn-grey" style="display: flex; align-items: center; justify-content: center; gap: 1rem" on:click|preventDefault={handleClickExportData}><i class="fa-solid fa-file-export fa-fw" />
                {$translations.export_data}
            </button>
        </div>
    {/if}
</section>

<style>
    .transactions-container {
        flex: 1 1 75%;
        transform: translateY(-0.6rem);
        padding: 0.5rem;
    }

    .heading {
        display: flex;
        justify-content: space-between;
    }

    .heading div {
        display: flex;
        align-items: center;
    }

    .heading img {
        width: 3rem;
        margin-right: 1rem;
    }

    .transactions-search {
        width: 100%;
        border-radius: 5px;
        border: none;
        padding: 1.4rem;
        margin-bottom: 1rem;
        background-color: #000;
        border-radius: 0.5vh;
        border: 4px solid rgb(0,238,255);
        box-shadow: 0 0 1.5vh rgb(0,238,255);
        color: #fff;
    }

    .scroller {
        height: 87%;
    }

    .export-data {
        margin-top: 1rem;
        display: flex;
        justify-content: flex-end;
    }
    /* ------------------------- */
</style>
