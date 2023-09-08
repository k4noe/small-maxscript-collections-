fn RGBtoHEX clrRGB = (bit.intAsHex clrRGB.r)+(bit.intAsHex clrRGB.g)+(bit.intAsHex clrRGB.b)
RGBtoHEX (color 80 170 178)
-->"50aab2"

--CONVERT  HEXSTRING TO RGB (0-255)
fn HEXtoRGB hexString = 
(
    local clr, hexValue = true, hexChars = "AaBbCcDdEeFe0123456789"
    if hexString[1] == "#" do trimleft hexString "#"
    if ((for c in 1 to hexString.count where findstring hexChars hexString[c] == undefined collect hexString[c]).count != 0) do hexValue = false
    if (hexValue == true and hexString.count == 6) do
    (
        local clrArr = for i = 1 to 5 where mod i 2 != 0 collect (append hexString[i] hexString[i+1])
        clr = (color (bit.hexAsInt clrArr[1]) (bit.hexAsInt clrArr[2]) (bit.hexAsInt clrArr[3]))
    ) ; return clr
)
HEXtoRGB "50aab2"
-->(color 80 170 178)


--CONVERT  RGB (0-255) TO FLOAT POINT COLOR
fn RGBtoFPC clrRGB = (color (clrRGB.r/255) (clrRGB.g/255) (clrRGB.b/255)) 
RGBtoFPC (color 80 170 178)
-->(color 0.313726 0.666667 0.698039)

--CONVERT  DOTNET COLOR TO RGB (0-255)
fn DOTNETtoMXSRGB dnClr = (local clr ; clr = if classof dnClr.r == Integer do (color dnClr.r dnClr.g dnClr.b) ; clr) 
DOTNETtoMXSRGB ((dotNetClass "System.Drawing.Color").LightGray)
-->(color 211 211 211)

