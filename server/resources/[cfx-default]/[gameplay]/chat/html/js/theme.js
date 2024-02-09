const theme = 'default';

const SetStyle = (style) => {
    var stylesheet = $("<link>", {
        rel: "stylesheet",
        type: "text/css",
        href: `./styles/${style}.css`
    });
    stylesheet.appendTo("head");
};

SetStyle(theme)