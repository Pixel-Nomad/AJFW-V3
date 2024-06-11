<script lang="ts">
    import VisibilityProvider from "./providers/VisibilityProvider.svelte";
    import { debugData } from "./utils/debugData";
    import AccountsContainer from "./components/AccountsContainer.svelte";
    import Popup from "./components/Popup.svelte";
    import Loading from "./components/Loading.svelte";
    import Notification from "./components/Notification.svelte";
    import { popupDetails, loading, notify, orderDetail, cardsDetail, accountsVisible, itemsDetails, pinDetails } from "./store/stores";
    import Order from "./components/order.svelte";
    import Cards from "./components/cards.svelte";
    import Items from "./components/items.svelte";
    import Pin from "./components/pin.svelte";

    debugData([
        {
            action: "setVisible",
            data: true,
        },
    ]);
</script>

<svelte:head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css" integrity="sha512-1sCRPdkRXhBV2PBLUdRb4tMg1w2YPf37qatUFeS7zlBy7jJI8Lf4VHwWfZZfpXtYSLy85pkm9GaYVYMfw5BC1A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</svelte:head>
<VisibilityProvider>
    {#if $accountsVisible.status}
        <AccountsContainer/>
    {/if}
    {#if $popupDetails.actionType !== ""}
        <Popup />
    {/if}
    {#if $orderDetail.status}
        <Order />
    {/if}
    {#if $cardsDetail.status}
        <Cards/>
    {/if}
    {#if $notify !== ""}
        <Notification />
    {/if}
    {#if $itemsDetails.status}
        <Items/>
    {/if}
    {#if $pinDetails.status}
        <Pin/>
    {/if}
</VisibilityProvider>
{#if $loading}
    <Loading />
{/if}
