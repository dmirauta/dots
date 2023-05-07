Modified keyboard layout to input greek characters on a modifier key, using this rather than an alternate layout since it does not necesarily reflect a modern greek layout or characters, more for convenient latex equations with the `alphabeta` package.

Should ideally just insert the diff, rather than copying edited files...

May be neater to do this with sxhkd, with something like the following?
```
r_ctrl + a
    <emulate-keypress-cmd> <alpha-keycode>
```

