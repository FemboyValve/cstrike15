# VPC-style file inclusion function for CMake
function(vpc_file OUTPUT_VAR)
    set(result_files)
    
    # Convert ARGN to a list for easier processing
    set(args_list ${ARGN})
    list(LENGTH args_list num_args)
    
    set(i 0)
    while(i LESS num_args)
        # Get the current file
        list(GET args_list ${i} current_file)
        math(EXPR i "${i} + 1")
        
        # Check if there's a condition following this file
        set(condition "")
        set(include_file TRUE)  # Default to include if no condition
        
        # Look ahead to see if next arguments form a condition
        if(i LESS num_args)
            # Collect all remaining arguments as potential condition parts
            set(condition_parts)
            set(j ${i})
            set(found_next_file FALSE)
            
            while(j LESS num_args AND NOT found_next_file)
                list(GET args_list ${j} potential_part)
                
                # Check if this looks like a file (has extension or path separators)
                if(potential_part MATCHES "\\.(cpp|c|hpp|h|cc|cxx)$" OR 
                   potential_part MATCHES "[/\\\\]" OR
                   potential_part MATCHES "^src/" OR
                   potential_part MATCHES "^[a-zA-Z]:")
                    set(found_next_file TRUE)
                else()
                    list(APPEND condition_parts "${potential_part}")
                    math(EXPR j "${j} + 1")
                endif()
            endwhile()
            
            # If we found condition parts, join them and evaluate
            if(condition_parts)
                string(JOIN " " condition ${condition_parts})
                set(i ${j})  # Move index past the condition
                
                # Evaluate the condition
                vpc_evaluate_condition("${condition}" include_file)
            endif()
        endif()
        
        # Add file if condition is met
        if(include_file)
            list(APPEND result_files "${current_file}")
        endif()
    endwhile()
    
    # Set the output variable in parent scope
    set(${OUTPUT_VAR} ${result_files} PARENT_SCOPE)
endfunction()

# Helper function to evaluate individual conditions
function(vpc_evaluate_condition condition result_var)
    set(result FALSE)
    
    # Handle compound conditions with AND
    if(condition MATCHES "^(.+) AND (.+)$")
        set(left_condition "${CMAKE_MATCH_1}")
        set(right_condition "${CMAKE_MATCH_2}")
        
        string(STRIP "${left_condition}" left_condition)
        string(STRIP "${right_condition}" right_condition)
        
        # Evaluate left condition
        vpc_evaluate_single_condition("${left_condition}" left_result)
        
        # Evaluate right condition  
        vpc_evaluate_single_condition("${right_condition}" right_result)
        
        if(left_result AND right_result)
            set(result TRUE)
        endif()
        
    # Handle compound conditions with OR
    elseif(condition MATCHES "^(.+) OR (.+)$")
        set(left_condition "${CMAKE_MATCH_1}")
        set(right_condition "${CMAKE_MATCH_2}")
        
        string(STRIP "${left_condition}" left_condition)
        string(STRIP "${right_condition}" right_condition)
        
        # Evaluate left condition
        vpc_evaluate_single_condition("${left_condition}" left_result)
        
        # Evaluate right condition
        vpc_evaluate_single_condition("${right_condition}" right_result)
        
        if(left_result OR right_result)
            set(result TRUE)
        endif()
        
    else()
        # Single condition
        vpc_evaluate_single_condition("${condition}" result)
    endif()
    
    set(${result_var} ${result} PARENT_SCOPE)
endfunction()

# Helper function to evaluate a single condition
function(vpc_evaluate_single_condition condition result_var)
    set(result FALSE)
    
    string(STRIP "${condition}" condition)
    
    # Handle NOT conditions
    if(condition MATCHES "^NOT (.+)$")
        set(inner_condition "${CMAKE_MATCH_1}")
        string(STRIP "${inner_condition}" inner_condition)
        vpc_evaluate_single_condition("${inner_condition}" inner_result)
        if(NOT inner_result)
            set(result TRUE)
        endif()
    else()
        # Check built-in CMake variables and custom variables
        if(condition STREQUAL "WIN32")
            if(WIN32)
                set(result TRUE)
            endif()
        elseif(condition STREQUAL "UNIX")
            if(UNIX)
                set(result TRUE)
            endif()
        elseif(condition STREQUAL "APPLE")
            if(APPLE)
                set(result TRUE)
            endif()
        elseif(condition STREQUAL "MSVC")
            if(MSVC)
                set(result TRUE)
            endif()
        else()
            # Check if it's a defined variable/option
            if(DEFINED ${condition})
                if(${condition})
                    set(result TRUE)
                endif()
            endif()
        endif()
    endif()
    
    set(${result_var} ${result} PARENT_SCOPE)
endfunction()