const ui = document.getElementById('RadialBar');
let running = false;
let customDial = false
let staticDial = false

window.onData = function (data) {
    if (data.display && !running) {
        if ( data.Type == 'linear' ) {
            customDial = new LineaRadialBar({
                w: data.Width,
                h: data.Height,
                x: data.x,
                y: data.y,
                padding: data.Padding,
                cap: data.Cap,                
                color: data.Color,
                bgColor: data.BGColor,
                progress: data.From,
                easing: data.Easing,
                onStart: function() {
                    running = true;

                    this.label.textContent = data.Label;

                    PostData("progress_start")
                },    
                onComplete: function () {
                    this.label.textContent = "";

                    PostData("progress_complete");

                    this.hide();

                    setTimeout(() => {
                        this.remove();
                    }, 1000)
                
                    running = false;
                }                    
            });
        } else if ( data.Type == 'radial' || !data.Type ) {
            customDial = new RadialProgress({
                r: data.Radius,
                s: data.Stroke,
                x: data.x,
                y: data.y,
                padding: data.Padding,
                cap: data.Cap,                
                color: data.Color,
                bgColor: data.BGColor,
                rotation: data.Rotation,
                maxAngle: data.MaxAngle,
                progress: data.From,
                easing: data.Easing,
                onStart: function() {
                    running = true;

                    this.container.classList.add(`label-${data.LabelPosition}`);
                    this.label.textContent = data.Label;

                    PostData("progress_start")
                },
                onComplete: function () {
                    PostData("progress_complete");

                    this.indicator.textContent = "";
                    this.label.textContent = "";
                    this.hide();

                    setTimeout(() => {
                        this.remove();
                    }, 1000)
                
                    running = false;
                }
            });
        }

        customDial.render(ui);

        customDial.start(data.To, data.From, data.Duration);
    }

    if ( data.static ) {
        if ( !staticDial ) {
            staticDial = new RadialProgress({
                r: data.Radius,
                s: data.Stroke,
                x: data.x,
                y: data.y,
                padding: data.Padding,
                cap: data.Cap,
                color: data.Color,
                bgColor: data.BGColor,
                rotation: data.Rotation,
                maxAngle: data.MaxAngle,
                progress: data.From,
                onChange: function(progress) {
                    if ( data.ShowProgress ) {
                        this.indicator.textContent = `${Math.ceil(progress)}%`;
                    }                
                },                 
            });

            staticDial.container.classList.add(`label-${data.LabelPosition}`);
            staticDial.label.textContent = data.Label;            
        } else {
            if (data.show) {
                staticDial.render(ui);
            }
        
            if (data.hide) {
                staticDial.remove();
            }               

            if ( data.progress !== false ) {
                staticDial.setProgress(data.progress)
            }

            if (data.destroy) {
                staticDial.remove();
                staticDial = false;
            }             
        }              
    }

    if (data.stop) {
        running = false;

        if ( customDial ) {
            customDial.stop();
            customDial = false
        }

        PostData("progress_stop");
    }
};

window.onload = function (e) {
    window.addEventListener('message', function (event) {
        onData(event.data);
    });   
};

function PostData(type, obj) {
    if ( obj === undefined ) {
        obj = {}
    }
    fetch(`https://${GetParentResourceName()}/${type}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(obj)
    }).then(resp => resp.json()).then(resp => resp).catch(error => console.log('RadialBar FETCH ERROR! ' + error.message));  
}