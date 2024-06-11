<script lang="ts">
  import { fetchNui } from '../utils/fetchNui';
  import { onMount } from 'svelte';
  import { 
    visibility,
    accounts,
    activeAccount,
    loading,
    notify,
    popupDetails,
    atm,
    translations,
    currency,

    orderDetail,

    cardsDetail,

    accountsVisible,

    itemsDetails,

    pinDetails





  } from '../store/stores';
  import { useNuiEvent } from '../utils/useNuiEvent';
  let isVisible: boolean;

  visibility.subscribe(visible => {
    isVisible = visible;
  });

  useNuiEvent<any>('setVisible', data => {
    accountsVisible.set({
          status:true,
    })
    accounts.set(data.accounts);
    activeAccount.update(() => data.accounts[0].id)
    visibility.set(data.status);
    loading.set(data.loading);
    atm.set(data.atm);
  })

  useNuiEvent<any>('openCardUI', data =>{
    visibility.set(data.status);
    itemsDetails.set({
      status:true,
      items: data.items,
    });
    loading.set(data.loading);
  })

  useNuiEvent<any>('setLoading', data => {
    loading.set(data.status);
  })

  useNuiEvent<any>('notify', data => {
    notify.set(data.status);
    setTimeout(() => {
      notify.set("");
    }, 3500);
  })

  useNuiEvent<any>('updateLocale', data => {
    translations.set(data.translations);
    currency.set(data.currency);
  })
  
  onMount(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (isVisible && ['Escape'].includes(e.code)) {
        fetchNui('closeInterface');
        visibility.set(false);
        popupDetails.update((val) => ({
          ...val,
          actionType: "",
        }));
        orderDetail.update(() => ({
          status:false,
          pin: 0,
        }));
        accountsVisible.update(()=>({
          status:false,
        }))
        cardsDetail.update(() => ({
          status: false,
          cards: [],
        }));
        itemsDetails.update(()=>({
          status:false,
          items:[],
        }))
        pinDetails.update(()=>({
          status:false,
          cardNumber: 0,
        }))
      }
    };

    window.addEventListener('keydown', keyHandler);
    return () => window.removeEventListener('keydown', keyHandler);
  });
</script>

{#if isVisible}
  <slot />
{/if}
