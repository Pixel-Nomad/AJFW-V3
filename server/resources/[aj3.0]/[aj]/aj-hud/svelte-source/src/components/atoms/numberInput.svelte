<script lang="ts">
  export let min: number = 0;
  export let max: number = 10;
  export let handleUpdateFunction: (val) => void = (_) => {};
  export let value: number = 1;
  export let step: number = 1;

  function checkConstraints(val: number) {
    if (val > max) {
      val = max;
    }
    if (val < min) {
      val = min;
    }
    return Math.round(val * 100) / 100;
  }

  function handleClick(op: "increase" | "decrease") {
    if (op == "increase") {
      value += step;
    } else {
      value -= step;
    }
    value = checkConstraints(value);
    handleUpdateFunction(value);
  }

  function handleInputUpdate(e: any) {
    if (e.target.value.endsWith(".")) {
      return;
    }
    let tempVal = Number(e.target.value);
    if (isNaN(tempVal)) {
      return;
    }
    value = checkConstraints(tempVal);
    handleUpdateFunction(value);
  }
</script>


<div style="border:1px solid #ff00fe;box-shadow: 0.2vh 0.2vh 0.9vh #ff0000;"  class="flex flex-row mx-auto border h-10 w-30 rounded-lg  relative text-black">
  <button style="border:1px solid #ff00fe;"  class="font-semibold border-r bg-[#ff005e] hover:bg-red-800 text-white  border-1 h-full w-20 flex rounded-l-md focus:outline-none cursor-pointer"
    on:click={() => handleClick("decrease")}>
    <span class="mx-auto mt-[10%] text-lg font-bold">-</span>
  </button>

  <input style="border:1px solid #ff00fe;"  type="text" class="w-15 p-2 p-1 text-xs appearance-none text-base  border-1 focus:outline-none focus:border-1 focus:border-gray-400 text-center bg-[#700000] text-white"
    bind:value={value} on:input={(e) => handleInputUpdate(e)}/>
  
  <button style="border:1px solid #ff00fe;"  class="font-semibold border-l bg-[#ff005e] hover:bg-green-600 text-white  border-1 h-full w-20 flex rounded-r-md focus:outline-none cursor-pointer"
    on:click={() => handleClick("increase")}>
    <span class="mx-auto mt-[10%] text-lg font-bold">+</span>
  </button>
</div>