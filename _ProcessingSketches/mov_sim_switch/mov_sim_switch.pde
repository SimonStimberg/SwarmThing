import processing.video.*;
Movie mov;

boolean mov_playing = false;
int counter = 0;

int SIM_LENGTH = 200;

void setup()
{
    size(1024,768);
    background(0);

    mov = new Movie(this, "panda.mov");
    imageMode(CENTER);
} 

void draw()
{
    
    if(mov_playing)
    {
        // Display the playing mov
        image(mov, width * 0.5, height * 0.5);
    }
    else
    {
        // Display the simulation
        if(counter < SIM_LENGTH)
        {
            sim();
            counter++;
        }
        // executed once when sim is done 
        // and the mov not yet playing
        else 
        {
            background(0);
            mov_playing = true;
            counter = 0;

            mov.play();
        }
    }
    
    //Check if the movie stopped
    // Apparently there is no isPlaying property in the
    // video lib
    if (mov_playing && mov.time() >= mov.duration()) 
    { 
        mov.stop();

        background(0);
        mov_playing = false;
    }
}


void movieEvent(Movie m)
{
    m.read();
}

void sim()
{
    circle(random(width), random(height), random(20, 100));
}