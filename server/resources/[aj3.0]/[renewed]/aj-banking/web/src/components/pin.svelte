<script lang="ts">
    import { loading, notify, pinDetails } from "../store/stores";
    let pin = "";
    function CloseCards() {
        pinDetails.update(() => ({ status: false, cardNumber: "" }));
    }
    function submit() {}
</script>

<section class="popup-container">
    <section class="popup-content">
        <h2>EnterPinCode</h2>
        <form action="#">
            <div class="form-row">
                <label for="amount">Enter pin Code</label>
                <input
                    bind:value={pin}
                    type="password"
                    name="pin"
                    id="pin"
                    placeholder="Enter Code"
                    maxlength="4"
                />
            </div>

            <div class="btns-group2">
                <button
                    type="button"
                    class="btn btn-green"
                    on:click={() => submit()}>Submit</button
                >
            </div>
        </form>
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
        height: 25%;
        background-color: #000;
        border-radius: 0.5vh;
        border: 4px solid rgb(0, 238, 255);
        box-shadow: 0 0 2.5vh rgb(0, 238, 255);
        padding: 2rem;
        overflow-y: hidden;
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
        color: #f3f4f5;
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
        background-color: #000;
        border-radius: 0.5vh;
        border: 4px solid rgb(0, 238, 255);
        box-shadow: 0 0 2.5vh rgb(0, 238, 255);
        color: #fff; 
    }
</style>
