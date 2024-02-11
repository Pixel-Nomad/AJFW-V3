description 'chat management stuff'

ui_page 'html/index.html'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
client_script 'cl_chat.lua'
server_script 'sv_chat.lua'

files {
    'html/index.html',
    'html/styles/*.css',
    'html/js/config.default.js',
    'html/js/theme.js',
    'html/js/App.js',
    'html/js/Message.js',
    'html/js/Suggestions.js',
    'html/vendor/vue.2.3.3.min.js',
    'html/vendor/flexboxgrid.6.3.1.min.css',
    'html/vendor/animate.3.5.2.min.css',
    'html/vendor/latofonts.css',
    'html/vendor/fonts/LatoRegular.woff2',
    'html/vendor/fonts/LatoRegular2.woff2',
    'html/vendor/fonts/LatoLight2.woff2',
    'html/vendor/fonts/LatoLight.woff2',
    'html/vendor/fonts/LatoBold.woff2',
    'html/vendor/fonts/LatoBold2.woff2',
  }


