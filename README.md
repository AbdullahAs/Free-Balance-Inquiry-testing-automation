![](http://www.forethinkingpeople.com/shared/graphics/ConstructionInProgressIcon01.gif) Work Under Progress ![](http://www.forethinkingpeople.com/shared/graphics/ConstructionInProgressIcon01.gif)

# Free Balance Inquiry testing automation script
To run series of MSISDNs against the Free Balance Inquiry service of Mobily

## Goal
To automate a task that can take a huge amount of hours

This script do the following as of V1.3:
* Send a GET request with a list of MSISDNs to FBI service.
* Parse the XML response
* Check if the MSISDN has some resources? otherwise ignore it
* Output a summary file with each MSISDN and its resources
* Output the result for each MSISDN into a text file as POT

## Reuirements
* Ruby
* Rubygems

## How to
In order to run this script, you just need to:
* Supply the MSISDNs.txt file with a list of MSISDNs
* Have Ruby installed in your machine
* Access to the right environment
* Run the script ./fbi_test.rb

## Example
![](https://cloud.githubusercontent.com/assets/904363/11667844/2302364c-9e05-11e5-9e53-bfa7fcd66730.png)

