
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
        $.post('/devices/' + element.data('device-id'), {control: id, value: value})
            .done(function(data) {
                // Optionally make a visual indication that the change has been successful
                // $(element).fadeTo(150, 0.5, function() { $(this).fadeTo(500, 1.0); });
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
            }
        });
        $('select.select-ha-control' + selector).val(msg.value);
    };
}
