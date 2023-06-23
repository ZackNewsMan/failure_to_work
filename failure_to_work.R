# Want to know how many people were dinged for a failure to work since Amendment A was passed on November 7, 2018 to date (June 12, 2023). 
  # Per NPR: http://leg.colorado.gov/sites/default/files/documents/2018A/bills/2018a_hcr1002_rn2.pdf 
  # https://www.npr.org/2018/11/07/665295736/colorado-votes-to-abolish-slavery-2-years-after-similar-amendment-failed
  # Denver Post: https://www.denverpost.com/2018/11/06/colorado-amendment-a-results/

  # Will need to use language "at least" when talking about it because the data is hella dirty and may not all be labeled properly. 
    # Ex: I am seeing repeat incident_numbers even though there are different dates for different infractions. 

library(tidyverse)

library(readr)
copd_failure_to_work <- read_csv("H:/Criminal cases of interest/Prison labor -- Amendment A/Failure to work data/copd_failure_to_work.csv")
View(copd_failure_to_work)

library(readr)
iar_failure_to_work <- read_csv("iar_failure_to_work.csv")
View(iar_failure_to_work)

# Merge them first

failure_to_work <- copd_failure_to_work %>% full_join(iar_failure_to_work)

    # Export to be able to follow along in SQL:
    
    failure_to_work %>% write_csv("failure_to_work.csv", na = "")

# Just the yes'
    
    failure_to_work %>% 
      filter(failure_to_work == "Yes")
    
    # Worked, 12,525 rows before looking for distinct incident numbers. 
      # SQL echoed, 12,525 rows.
    
        # select *
        #  from failure_to_work
        # where failure_to_work = "Yes"
        
    # But, I definitely could've named that in a less confusing way between column and table names. But alas. 
    
    no_show <-  failure_to_work %>% 
      filter(failure_to_work == "Yes")
    
###### unique incident numbers #########
    
    no_show %>% 
    distinct(incident_number, .keep_all = TRUE) %>% 
    View()

    # 727 rows. 
      # Echo'd in SQL, 727 rows
      
      # create table "no_show" as
      # select *
      #  from failure_to_work
      # where failure_to_work = "Yes"
      
      # no_show %>% 
      #  distinct(incident_number, .keep_all = TRUE)
      
    distinct_no_show <- no_show %>% 
      distinct(incident_number, .keep_all = TRUE)
    
    distinct_no_show %>% write_csv("distinct_no_show.csv", na = "")
    
####### by year #########
    
    distinct_no_show %>% 
      group_by(year) %>% 
      summarize(count = n()) 
    
    # There were at least 154 failure to work notations in 2022, which is down from a high of 207 incidents in 2019. 
      # Same in SQL: 
        # CREATE TABLE "distinct_no_show" as
        # SELECT DISTINCT(incident_number), summary, year, facility, docno
        # from no_show
        # group by incident_number
        
        # SELECT year, count(year)
        # from distinct_no_show
        # group by year
    
    
######## by facility ########
    
    distinct_no_show %>% 
      group_by(facility) %>% 
      summarize(count = n()) %>% 
      View()
    
    # Incidents of inmates failing to work happened at 20 facilities across the state but were concentrated in the Sterling Correctional Facility, where at least 245 incidents occurred. 
      # Same thing in SQL, most incidents happened at Sterling
    
        # SELECT facility, count(facility)
        # from distinct_no_show
        # group by facility
        # order by count(facility) desc
    
    
####### by inmate #############    
  # Assuming DOCNO corresponds with unique inmate ID but not 100% sure so going to hold off. But this would be the code:  
    
    distinct_no_show %>% 
      group_by(docno) %>% 
      summarize(count = n()) %>% 
      View()
