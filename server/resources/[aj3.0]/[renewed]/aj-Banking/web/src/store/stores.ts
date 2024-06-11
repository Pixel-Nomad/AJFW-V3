import { writable } from "svelte/store";

export const visibility = writable(false);
export const loading = writable(false);
export const notify = writable("");
export let activeAccount = writable(null);
export const atm = writable(false);
export const currency = writable("USD");

interface PopupDetails {
    account: {
        id: any,
        type:any,
    };
    actionType: string;
}
export let popupDetails = writable<PopupDetails>({
    account: {
        id: undefined,
        type: undefined
    },
    actionType: "",
});

export let orderDetail = writable({
    status: false,
    pin: 0,
});

interface Cards {
    id: number;
    blocked: number;
    limit: number;
    maxlimit: number;
    account: number;
    card: any;
}

interface CardsDetail {
    status: boolean;
    cards: Cards[];
}

export const cardsDetail = writable<CardsDetail>({
    status: false,
    cards: []
});

export const accountsVisible = writable({
    status: false
})

export const accounts = writable<any>();


interface itemsDetails {
    status: boolean;
    items: any[];
}

export const itemsDetails = writable<itemsDetails>({
    status: false,
    items: []
});

interface pinDetails {
    status: boolean;
    cardNumber: string;
}

export const pinDetails = writable<pinDetails>({
    status: false,
    cardNumber: ''
});


export const translations = writable<any>();