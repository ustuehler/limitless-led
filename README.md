limitless-led
=============

A Ruby client library for controlling the [LimitlessLED v3.0 RGBW color-changing light bulbs](http://www.limitlessled.com/),
based on the official [LimitlessLED API documentation](http://www.limitlessled.com/dev/).

**This is a very early Alpha / proof-of-concept.** It works, but it's missing a lot of features that 
hopefully we'll have time to add soon.

## Usage

    bridge = LimitlessLed.new(host: '192.168.1.100', port: 8899)
    
    bridge.all_on        # all lights are on
    bridge.all_off       # all lights are off
    bridge.white         # all lights are white
    bridge.disco         # disco mode!
    bridge.disco_faster  # disco mode faster
    bridge.disco_slower  # disco mode slower
    
## Note

We are *not affiliated in any way* with the manufacturers of Limitless LED. We just think they are cool.

## License

The MIT License (MIT)

Copyright (c) 2013 Hired, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
