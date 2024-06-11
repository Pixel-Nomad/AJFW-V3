<script lang="ts">
    import AccountsList from "./Accounts/AccountsList.svelte";
    import AccountTransactionsList from "./Accounts/AccountTransactionsList.svelte";
    import { accounts } from '../store/stores';
    import { formatMoney } from "../utils/misc";
</script>

<div class="main">
    <section>
        <AccountsList />
        <AccountTransactionsList />
    </section>
    <h5><i class="fa-solid fa-wallet fa-fw"></i>{formatMoney($accounts[0].cash)}</h5>
</div>

<style>
    .main {
        overflow: hidden;
        width: 80%;
        height: 80%;
        bottom: 12%;
        left: 10%;
        padding: 1rem;
        position: absolute;
        background-color: rgb(0, 0, 0);
        border-radius: 0.5vh;
        border: 4px solid rgb(0,238,255);
        box-shadow: 0 0 2.5vh rgb(0,238,255);
        background-size: cover;
        background-position: center;
        opacity: 1;
    }

    section {
        display: flex;
        gap: 4rem;
        height: calc(100% - 6rem);
    }
    h5 {
        font-size: 1.4rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
</style>
