extends Node
 
 
var size = Vector2(16,16)                        ## size of the grid needed (horizontal/vertical)
var steps = 32                                   ## how many tiles/rooms will be randomly placed
var grid = []                                    ## an empty array that will hold our objects positions
 
var room_size = Vector2(64, 64)
 
func _ready():                                   ##running all the functions in order
    grid_build()
    grid_randomize()
    grid_debug_display()                         ##optional printing in the console
    grid_populate()
#   grid_clear()                                 ##this should be run when the grid should be destroyed
 
 
 
###BUILD GRID:
func grid_build():                                
    for v in range(size.y):                       ##iterate trough the vertical size of the array
        grid.append([])                           ##append an empty nested array
        for h in range(size.x):                   ##iteration trough the horizonal part of the array
            grid[v].append(0)                     ##append a zero "size.x" times for each nested array
 
###RANDOMIZE GRID:
func grid_randomize():
    var x = round(size.x/2)                       ##starting horizontal position of the instantiator
    var y = round(size.x/2)                       ##starting  vertical  position of the instantiator
 
 
    var i = 0                                     ##scope variable for objects placed
    while (i < steps):                            ##while objects placed are less then the desired objects (steps)
        randomize()                               ## randomize the number generation
       
        if grid[x][y] == 0:                       ##check if there's an object (1) on this position
            grid[x][y] = 1                        ##if not -> create one
            i += 1                                ##set the loop to the next stage
 
        else:                                     ##if an object was already placed on this position
            var dir = (randi() % 4) * 90          ##get a random number between 0 and 360
            x += sin(deg2rad(dir))                ##for the horizontal get the sin of the direction in degrees (-1, 0 or 1)
            y += cos(deg2rad(dir))                ##for the vertical get the cos of the direction in degrees (-1, 0 or 1)
            x = clamp(x, 0, size.x-1)             ##clamp the possible position to be inside the size of the array
            y = clamp(y, 0, size.y-1)             ##clamp the vertical position
 
 
### DEBUG : PRINT GRID:
func grid_debug_display():                        ## This is a function made just for debugging. It prints the grid in the console
    for i in range(size.y):                       ## It prints every nested array in a new line for easier reading
        print(grid[i])                            ##
    print("---------------")                      ## This is just a separator at the end in case more then one level is built
 
### ADD PROPER OBJECTS IN THE GRID:
func grid_populate():
    var base_room = preload("res://path to the object we will use")             ##load the base tile/room
 
    for y in range(size.y):                                                     ##iterate trough the vertical
        for x in range(size.x):                                                 ##iterate trough the horizontal
            if grid[y][x] == 1:                                                 ##if the current number = 1 (there is an object to be placed)
                var room_instance = base_room.instance()                        ##create instance of the tile/room
                room_instance.set_pos(Vector2(x * room_size.x ,y*room_size.y))  ##set the position of the object to be the position of the grid * by the size of the tile
                                                                                ## ** here any other property of the current object
                                                                                ## ** can be changed (name, z index etc)
                add_child(room_instance)                                        ##add the object as a child
 
 
### CLEAR THE ARRAY AND DESTROY ALL OBJECTS:
func grid_clear():                                    
    ##Destroy all objects:
    for child in range (get_children().size()):     ##get all the children of the object one by one
        get_child(child).queue_free()               ##destroy the current child (that sounds worse then it is ...)
 
    ##Clear the array:
    grid.clear()                                    ##clear the array so a new level can be created
