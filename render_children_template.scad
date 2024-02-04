// Created 2023-2024 by Dan Brown

/*
 - General purpose class template for functions and modules pertaining
     to aligning modules/ children/ parts or other objects.
     
 - *Again, this is a template. It can be used as is or changed/ 
    expanded upon - it is a general guide or form for doing things.
    Not an absolute. And as such:
  
 - This work is released with CC0 into the public domain.
    https://creativecommons.org/publicdomain/zero/1.0/  
      
 - Main use case is for allowing the rendering and snapshoting of 
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
      
      This allows us to avoid writing and rewriting newb-like logic
      that looks like:  
      
      if num==1, then module1(), 
      else if num==2, then module2();
      
      Even if it's a switch case statement, it is still hard to read and
      maintain. 
      
      It is much easier to simply supply essentially a list of different
      modules (or children or parts -- really the same thing if you
      abstract it out). And then supply another list of the names of 
      those modules. However...
      
    NOTE: 
        - Mapping between parts and their associated colors MUST match 
            the order of the defined parts/ children in whatever calls the
            align_parts_line() module! 
            Otherwise, you will get mis-matched names to exported objects.

    - See render_children_template_example.scad for an example.
*/



// :: Parameters ::


// if no color is assigned to a part
part_color_default = "black";    

// Text parameters - default for when showing the text of part
text_height = 5;


// :: Functions ::


 // Return object color based on name of the part
function get_color(part, parts = [ [undef, undef]] ) =
    let (return_color_indexes = search([part], parts,                                     num_returns_per_match=1) )
    
    // grab first element of returned list of indexes
    let (first_returned_index = return_color_indexes[0])

    // check to see if the returned first element might be another list
    // ---> in this case, it would mean it is an empty list
    // if not, then grab color associated with first returned index
    let (return_color = is_list(first_returned_index) ?                        part_color_default : 
                            parts[ first_returned_index][1] )
    
    return_color;


// :: Modules ::


/* Align parts / modules in a line
    - This allows us to see a breakdown of the parts
        and also to save them individually for 3D printing / processing

    - *NOTE:  
        The supplied parts (associative) array MUST match the order 
        of the children that are supplied to this module!
        Otherwise, there will be mis-matched objects!
        
    - Again, see render_children_template_example.scad for an example.
*/         
module align_parts_line(dist, text_alignment, text= false,
                         child_rotation = [0,0,0],
                         child_num = -1, 
                         parts = [ [undef, undef]] ) {
    
    // default of -1 for child_num means we want to see all children
    loop_start = child_num > -1 ? child_num : 0;
    loop_end = child_num > -1 ? child_num : $children-1; 
    
    text_side_align = 0;    // extra left / right displacement of text

    // Change dist to be 0 (in the center) to see a specific child
    dist = child_num > -1 ? 0 : dist; 
    
    // Loop through children
    for ( i = [loop_start:1:loop_end] ) {      
      part_text = parts[i][0];      // get name of child/ part

      translate([0, (i-$children/2)*dist, 0]) {
          // color of the parts is the same as color of the text
          color(get_color(part_text, parts)) 
          rotate(child_rotation)    // rotate current child (if wanted)  
            children(i);    // display the current child
          echo(part_text);     // echo child name, which can be used later
          
          // show text
          if(text) {
              translate([text_alignment, text_side_align, 0]) {
                rotate([0,0,90]) {
                    color(get_color(part_text, parts))
                    text3d(part_text);  
                }
              }
          }    
      }
      
    }
}


// Generate 3D Text 
module text3d(text_string, text_height=text_height) {
    linear_extrude(text_height)
        text(text_string, halign="center");
}
