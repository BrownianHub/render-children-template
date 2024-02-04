# render-children-template
------------------------------------------------------

Created 2023-2024 by Dan Brown
------------------------------------------------------

Stop doing newb-like logic when trying to render modules/ parts one at a time:
```
if num==1, then module1(), 
else if num==2, then module2();
 ```

And instead, add all your parts/ modules into a openscad file like so
(under where it says "Supply children here"):
```
module render_scene(child_num, text=true) {
    // call align parts line module
    align_parts_line(dist = 150, text_alignment = 40, text=text, 
                        parts = child_text_color, child_num=child_num) {
                            
        // *** Supply children here:  ***     
                            
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
```

Define the parts with their names and colors, like so:
```
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
```

Then call the defined render module to do the rendering like so:
```
// Default initilizations
childNum = -1;  

// Create and align parts in a line
render_scene(child_num = childNum);
```

Combine with the render.sh script to then call OpenScad from commandline, 
and watch as it creates renders or snapshots of the parts automatically!

- See render_children_template_example.scad for an example.
------------------------------------------------------

A General purpose OpenScad class template for functions and modules pertaining
     to aligning modules/ children/ parts or other objects and then 
     rendering or snapshoting them.
     
-   Again, this is a template. It can be used as is or changed/ 
    expanded upon - it is a general guide or form for doing things.
    Not an absolute. And as such:
  
 - This work is released with CC0 into the public domain.
    https://creativecommons.org/publicdomain/zero/1.0/  
      
 -    The main use-case is for allowing the rendering and snapshoting of 
      individual parts (when combined with a bash script such as
      "render.sh") one at a time in a loop.
      
      This works by using echoing to echo out the name of parts
      (specified by a parts array that can be supplied to the
      align_parts_line module). The bash script will have OpenScad
      output those echoed names into a file, and then read that file.
      
      It will then call on OpenScad again to render or snapshot 
      the same scad file (that was used to get the echoed names), 
      but this time, it will do so in a loop, supplying the child_num
      value based on the iteration of the loop. 
     
      It will then map the name of the child to the child being rendered, 
      and save it with that name as an stl or png or whatever you want
      to export it as (will need to slightly alter the script to have it
      output a specific file type - default is to render export as stl).
      
      The align_parts_line module is designed to work in such a way 
      that if child_num > -1, then we see all children in a line,
      otherwise, we see the specific child at the specified index.
      
      
NOTE: 
   - Mapping between parts and their associated colors MUST match 
       the order of the defined parts/ children in whatever calls the
       align_parts_line() module! 
       Otherwise, you will get mis-matched names to exported objects.
