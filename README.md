# spread_infection_in_social_network

## Project description
In my project I will construct an app that simulates the spread of an infectious disease on the user’s own social network. 
I will start with implementing a user interface, which is used to create the social network. 
When this works correctly and the user can change several aspects (e.g. gender of friends in his/her social network), I will add the part that simulates the infection. 
If I am short on time, I will reduce the number of features the user can change about his/her social network. 
On the contrary, if I have extra time, I would like to expand the input options for the user, and include the reproductive factor of the corona-virus in the world/Netherlands in the simulation.

## Code
I will implement this app in Python. Packages I will use will (probably) include ```networkx``` (including .Graph function) to construct the network, ```matplotlib``` (including .pyplot.plot) to plot the network. Besides this I will probably use some inbuild functions like ```input``` ask user for input. In addition, I will make several functions, including: 
* create_network: function that creates a network from user input about social network (using the input, networkx.Graph and plot function).
* simulate_spread: start with one node that gets infected, and simulate how the infection would spread throughout the network. Every time this function is called, it will update which nodes are infected, and this will be used to create a new network.

##FLOW
[ask user for input] > [create network] > [ask user for input] > [update network] > [… repeat this as much as wanted] > [simulate spread]

