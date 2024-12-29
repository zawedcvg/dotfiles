require('illuminate').configure({
    delay = 200,
    filetypes_denylist = {
        'dirvish',
        'fugitive',
        'help',
        'vim',
        'txt'
    },
    providers_regex_syntax_denylist = {'vim', 'txt'},
    under_cursor = true,
})
