contact = ampdataIn>0.05;   % find all points with acceleration above the
                            % threshold of 0.05
ContactTimes = sum(contact) % compute the number of timepoints above treshold
timeOfContact = sum(contact)/FreqIn % time of contact

speed1 = trapz(timedataIn,ampdataIn.*contact)
speed2 = trapz(timedataIn(dom),ampdataIn(dom)) % dom is defined in ReadDataDLM
