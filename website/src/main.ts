import './style.scss'
import { HoverMode, InteractivityDetect, IOptions, RecursivePartial, tsParticles,  } from 'tsparticles';
import { IParticles } from 'tsparticles/Options/Interfaces/Particles/IParticles';

(async () => {
    const pollenParticles: RecursivePartial<IParticles> = {
        size: {
        value: {
            min: 1,
            max: 4
        }
        },
        color: {
            value: ['#fcd858', '#e3f542', '#fcef58']
        },
        move: {
            enable: true,
            direction: 'none',
            speed: {
                min: 0.1,
                max: 1
            }
        }
    };

    const options: RecursivePartial<IOptions> = {
        autoPlay: true,
        fpsLimit: 60,
        fullScreen: true,
        motion: {
            disable: false,
        },
        particles: {
            ...pollenParticles
        },
        interactivity: {
            detectsOn: InteractivityDetect.window,
            events: { 
                onHover: {
                    enable: true,
                    mode: HoverMode.repulse,
                }
            },
            modes: {
                repulse: {
                    distance: 150
                }
            }

        },
        retina_detect: true,
    }
    
    await tsParticles.load('tsparticles', options);
})();