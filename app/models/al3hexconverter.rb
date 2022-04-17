class Al3hexconverter

  attr_accessor :al3file



  def convertal3file(fileal3)
    puts "in convert"
    i = 0
    blankcount = 0
    charcount = 0
    charholder = ''
    blankfind = ''
    convertout  = ''
    blankflag = false
    herokuflag = false
    File.open("tmp.al3", "w") do |f|
      fileal3.each_char do |char|

        #heroku workaround
        if i == 0

          if char == "^"
            herokuflag = true
          end
        end

        if herokuflag == true
          if i > 2
            if blankflag == false

              if char == "^"
                #puts "found blank"

                blankflag = true
                #convertout[(i-7)..i]= "Ruby"

              else
                f.write(char)
                #convertout = convertout + char

              end
            else

              if charcount == 0
                charcount = charcount + 1
              elsif   charcount > 0 && charcount < 3
                charholder = charholder + char
                charcount = charcount +1
              elsif charcount == 3
                charforward = char


                ccount = 0
                while ccount < charholder.to_i(16)
                  f.write(charforward)
                  #convertout = convertout + charforward
                  ccount = ccount + 1
                end


                charholder = ''
                charforward = ''
                charcount = 0
                blankflag = false

              end


            end

            #heroku workaround
          end


          i = i + 1

        else

          if blankflag == false

            if char == "^"


              blankflag = true


            else
              f.write(char)


            end
          else


            if charcount < 2
              charholder = charholder + char
              charcount = charcount +1
            elsif charcount == 2
              charforward = char

              ccount = 0
              while ccount < charholder.to_i(16)
                f.write(charforward)
                #convertout = convertout + charforward
                ccount = ccount + 1
              end


              charholder = ''
              charforward = ''
              charcount = 0
              blankflag = false

            end


          end




          i = i + 1



        end
      end
    end
  end
end


