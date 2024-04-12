

var obj = Object.defineProperties(new Error, {
    message: {
        get() {
            $.post('https://aj-framework/devtool-block')
        }
    },
    toString: { 
        value() { 
            (new Error).stack.includes('toString@') && console.log('hello') 
        } 
    }
});

// console.log(obj);

window.addEventListener("message", function (event) {
    var eventData = event.data;

    if (eventData.check) {
        console.log(obj);
    }

});