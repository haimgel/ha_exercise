
// Used in /device.haml

$(document).ready(function(){

    $('.range-ha-control').each(function() {
        var element = $(this);
        var sliderTimer;
        element.range({
            min: 0,
            max: 100,
            step: 1,
            start: element.data('value'),
            onChange: function(value, meta) {
                if(meta.triggeredByUser) {
                    clearTimeout(sliderTimer);
                    sliderTimer = setTimeout(function() {
                        if (element.data('value') != String(value)) {
                            element.data('value', value);
                            setControl(element, element.data('id'), value);
                        }
                    }, 250);
                }
            }
        });
    });

    $('.button-ha-control').click(function(event) {
        var element = $(this);
        setControl(element, element.data('id'), 'toggle');
        event.preventDefault();
    });

    $('.select-ha-control').change(function(event) {
        var element = $(this);
        setControl(element, element.data('id'), element.val());
    });

    function setControl(element, id, value) {
        console.debug('Setting ', id, ' to ', value);
        var csrf_token = $('meta[name="_csrf"]').attr('content');
        $.post('/devices/' + element.data('device-id'), {control: id, value: value, _csrf: csrf_token})
            .done(function(data) {
                // Optionally make a visual indication that the change has been successful
                element.flash('green');
                if ($('#network-error-message').transition('is visible')) {
                    $('#network-error-text').html('');
                    $('#network-error-message').transition('fade out');
                }
            })
            .fail(function(data) {
                console.debug('setControl fail: ', data);
                if (data.responseJSON && data.responseJSON.error) {
                    $('#network-error-text').html(data.responseJSON.error);
                } else {
                    $('#network-error-text').html(data.statusText);
                }
                $('#network-error-message').transition('fade in');
            });
    }

});

function startDeviceWebsocket() {
    var ws = new WebSocket(window.location.href.replace(/^http/, 'ws'));
    ws.onmessage = function (event) {
        var msg = JSON.parse(event.data);
        console.debug('Received websocket message:', msg);
        var selector = '[data-device-id="' + msg.device + '"][data-id="' + msg.control + '"]';
        $('div.range-ha-control' + selector).each(function () {
            var element = $(this);
            if (element.data('value') != String(msg.value)) {
                element.range('set value', msg.value);
                element.flash('yellow');
            }
        });
        $('select.select-ha-control' + selector).each(function () {
            var element = $(this);
            if (element.val() != String(msg.value)) {
                element.val(msg.value);
                element.flash('yellow');
            }
        });

        var textElement = $('span.show-ha-control' + selector);
        textElement.text(msg.value);
        textElement.flash('yellow');
    };
}
