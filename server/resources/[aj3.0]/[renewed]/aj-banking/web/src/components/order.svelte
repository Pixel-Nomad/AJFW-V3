<script lang="ts">
    import { loading, notify, orderDetail } from '../store/stores';
    import {fetchNui} from '../utils/fetchNui';
    let pin: number;
    function CloseOrder() {
        orderDetail.update(() => ({
            status : false,
            pin: 0
        }));
    }
    function isOnlyNumbers(input: any) {
        const regex = /^[0-9]+$/;
        return regex.test(input);
    }

    function submitInputOrder() {
        if (pin !== undefined) {
            if (isOnlyNumbers(pin)){
                const strNum = pin.toString();
                const digitCount = strNum.length;
                if (digitCount === 4) {
                    loading.set(true);
                    fetchNui('Order', {pin: pin}).then(retData => {
                        if (retData !== '' && retData !== true){
                            notify.set(retData);
                            setTimeout(() => {
                                notify.set("");
                            }, 3500);
                        }
                        setTimeout(() => {
                            loading.set(false);
                        }, 1000);
                    })
                    CloseOrder();
                } else {
                    notify.set("Enter 4 digit code only");
                    setTimeout(() => {
                        notify.set("");
                    }, 3500);
                }
            } else {
                notify.set("Only 0 to 9 number supported");
                setTimeout(() => {
                    notify.set("");
                }, 3500);
            }
        } else {
            notify.set("Enter 4 digit code");
            setTimeout(() => {
                notify.set("");
            }, 3500);
        }
    }
</script>

<section class="popup-container">
    <section class="popup-content">
    <h2>ORDER CARD for $5000</h2>
    <form action="#">
        <div class="form-row">
            <label for="amount">Enter pin Code</label>
            <input bind:value={pin} type="password" name="pin" id="pin" placeholder="Enter Code" maxlength="4"/>
        </div>

        <div class="btns-group">
            <button type="button" class="btn btn-red" on:click={CloseOrder}>Cancle Order</button>
            <button type="button" class="btn btn-green" on:click={() => submitInputOrder()}>Order Now</button>
        </div>
    </form>
</section>
</section>

<style>
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
        max-width: 60rem;
        width: 100%;
        background-color: #000;
        border-radius: 0.5vh;
        border: 4px solid rgb(0,238,255);
        box-shadow: 0 0 2.5vh rgb(0,238,255);
        padding: 5rem;
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
    .form-row label,
    .form-row input {
        font-size: 1.4rem;
        color: inherit;
    }

    .form-row input {
        width: 100%;
        border-radius: 5px;
        background-color: transparent;
        border: none;
        padding: 1.4rem;
        margin-bottom: 1rem;
        background-color: rgba(0,238,255,0.1);
        color: #fff; 
    }
</style>