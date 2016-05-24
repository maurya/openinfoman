import module namespace csd_bl = "https://github.com/openhie/openinfoman/csd_bl";
declare default element  namespace   "urn:ihe:iti:csd:2013";
declare variable $careServicesRequest as item() external;

(: 
   The query will be executed against the root element of the CSD document.
    
   The dynamic context of this query has $careServicesRequest set to contain any of the search 
   and limit paramaters as sent by the Service Finder
:) 

<CSD xmlns:csd="urn:ihe:iti:csd:2013"  >
  <organizationDirectory/>
  <serviceDirectory>
    {
      let $svcs0 := if (exists($careServicesRequest/requestParams/id))
	then csd_bl:filter_by_primary_id(/CSD/serviceDirectory/*,$careServicesRequest/requestParams/id)
      else /CSD/serviceDirectory/*
    	
      let $svcs1 := if(exists($careServicesRequest/requestParams/codedType))
	then csd_bl:filter_by_coded_type($svcs0,$careServicesRequest/requestParams/codedType) 
      else $svcs0

      let $svcs2 :=  if (exists($careServicesRequest/requestParams/record))
	then csd_bl:filter_by_record($svcs1,$careServicesRequest/requestParams/record)
      else $svcs1

      return if (exists($careServicesRequest/requestParams/start)) then
	if (exists($careServicesRequest/requestParams/max)) 
	  then csd_bl:limit_items($svcs2,$careServicesRequest/requestParams/start,$careServicesRequest/requestParams/max)         
	else csd_bl:limit_items($svcs2,$careServicesRequest/requestParams/start,<max/>)         
      else
	if (exists($careServicesRequest/requestParams/max)) 
	  then csd_bl:limit_items($svcs2,<start/>,$careServicesRequest/requestParams/max)         
	else $svcs2

    }     
  </serviceDirectory>
  <facilityDirectory/>
  <providerDirectory/>
</CSD>
