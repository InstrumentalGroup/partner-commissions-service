/* 
    Don't have any networking components created and/or set-up for the app?

    Set ´include_networking = true´ if you don't have any networking set-up
    that you want to attach this infrastructure to; setting this parameter
    to `true` will create and set-up all the networking components for the
    infrastructure to run the app correctly. (e.g. vpc, subnets, etc).

    If you set ´include_networking = true´ there is no need to specify
    the values for the rest of the variables, they will be ignored. 

    ------------------------------------------------------------------------

    Already have networking components created and set-up for the app?

    Set ´include_networking = false´ if you already have a networking set-up
    that you want to attach the infrastructure to; setting this parameter
    to `false` will require you to specify the ids of these existing -
    networking components (the ones below the include_networking var).

    If you set ´include_networking = false´ and don't specify the values
    of the ids of the existing components, then, the operation will fail. 
*/

include_networking   = false

vpc_id               = "vpc-8fc695f4"
subnet_a_id          = "subnet-223bd57e"
subnet_b_id          = "subnet-2e56a849"
security_group_id    = "sg-b69783ff"
internet_gateway_id  = "igw-cf7a1bb7"
