class Reportingwarehouse < ActiveRecord::Base


  def policycountreport(agencyid, atype)
    if atype =="Retail"
      @ppts =  Reportingwarehouse.find_by_sql(["SELECT book_month, book_year, Count(new_business_count) as newcount,Count(renewal_count) as renewcount FROM reportingwarehouses GROUP BY book_month, book_year, agency_id HAVING agency_id = ? AND book_year = ? ORDER BY book_year ASC, book_month ASC",  agencyid, Date.today.year])

    else
      @ppts = Reportingwarehouse.find_by_sql(["SELECT book_month, book_year, Count(new_business_count) as newcount,Count(renewal_count) as renewcount FROM reportingwarehouses GROUP BY book_month, book_year, generalagency_id HAVING generalagency_id = ? AND book_year = ? ORDER BY book_year ASC, book_month ASC",  agencyid, Date.today.year])

    end
  end


end
