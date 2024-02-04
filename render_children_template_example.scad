use <render_children_template.scad>;

// Created 2023-2024 by Dan Brown

/*

 - Example class showcasing how to use render_children_template.scad
 
 - You can use the supplied render.sh bash script file to export
    each child/ module/ part below, one by one. 
    See the render.sh file for more information.
     
 - This work is released with CC0 into the public domain.
    https://creativecommons.org/publicdomain/zero/1.0/ 
       
*/


// Colors used for different parts
part_colors = ["white", "yellow", "green"];


/* Mapping between parts and their associated colors
      *NOTE:  Must match the order of children defined in whatever 
                calls the align_parts_line() module! 
*/
child_text_color = [ 
["Tall Cube", part_colors[0] ],
["Wheel", part_colors[1] ],
["Flat Wheel", undef ]      
// Can even supply undef color as above to not override already 
//   supplied colors to a module. Comes in handy.
];


/* Example of putting align_parts_line in a specific module for rendering:
 - AKA: All you have to do is change these with the modules/ children 
      you want to render! Add as many as you like!
 - Set text=false, to not render/ display the text of the object.
*/
module render_scene(child_num, text=true) {
    // call align parts line module
    align_parts_line(dist = 150, text_alignment = 40, text=text, 
                        parts = child_text_color, child_num=child_num) {
                            
        // Supply children here:      
                            
        // Child 1
        scale([4,5,7])                    
        cube(5, center=true);
                      
        // Child 2       
        rotate([90,0,0])                        
        cylinder(d = 30, h = 10);     
                          
        // Child 3                              
        cylinder(d = 30, h = 10);                      
               
        // Child 4  --> notice how this is not defined
        //    Thus, its text does not show up, and it is the default color.
        sphere(10);                    
                            
    }
}


// Default initilizations
childNum = -1;  

// Create and align parts in a line
render_scene(child_num = childNum);
