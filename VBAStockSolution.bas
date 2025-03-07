Attribute VB_Name = "VBAStockSolution"
Sub analyzeStocksData()


Dim ws As Worksheet 'Worksheet object
'Stabilize the OS and Excel to run efficiently

Application.DisplayAlerts = False
Application.ScreenUpdating = False

For Each ws In ThisWorkbook.Worksheets

ws.Activate


'Declare variables


Dim tickerLabel As String         'For the variable/column name Ticker
Dim openingPrice As Double        'For holding the opening price
Dim closingPrice As Double        'For holding the closing price

Dim yearlyChange As Double        'For holding the Yearly Change
Dim percentChange As Double       'For holding the Percent Change
Dim totalVolume As Double         'For holding the sum off all stock volumes
Dim summaryTableRow As Integer    'Will help in referencing the location of each ticker in the Summary Table
Dim greatestIncrease As Double    'For holding the greatest increase
Dim greatestDecrease As Double    'For holding the greatest decrease
Dim greatestVolume As Double      'For holding the Greatest Volume


'Set the variables
tickerLabel = ""
totalVolume = 0
summaryTableRow = 2     'starts in row 2 of the specified column

greatestIncrease = Cells(2, 11)
greatestDecrease = Cells(2, 11)
greatestVolume = Cells(2, 12)

    'Set the value for the last row
    
    lastRow = Cells(Rows.Count, 1).End(xlUp).Row

    'Write the headers of the summary table
        
        Range("I1") = "Ticker"
        Range("J1") = "Yearly Change"
        Range("K1") = "Percent Change"
        Range("L1") = "Total Stock Volume"


        Range("O2") = "Greatest % Increase"
        Range("O3") = "Greatest % Decrease"
        Range("O4") = "Greatest Total"
        Range("P1") = "Ticker"
        Range("Q1") = "Value"

    'Format the percent change format to display % in 2 d.p.
        
        Columns("K:K").NumberFormat = "0.00%"

    'Read and extract from the data range

        For i = 2 To lastRow 'Iterate through the dataset

          'if ticker in previous cell and ticker in current cell not identical then ...
            If Cells(i - 1, 1).Value <> Cells(i, 1).Value Then
                openingPrice = Cells(i, 3)

          'if ticker in next cell and that in current cell not identical then ...
            ElseIf Cells(i, 1).Value <> Cells(i + 1, 1).Value Then

                'simulatenously for row i of this iteration,

                'set the ticker label
                tickerLabel = Cells(i, 1).Value

                'set the closing price
                closingPrice = Cells(i, 6).Value

                'add to the total volume
                totalVolume = totalVolume + Cells(i, 7).Value

                'calculate the yearly change i.e. the difference between closing and opening price
                yearlyChange = closingPrice - openingPrice

                'calculate the percentage change i.e yearly change / opening price
                 
                 ' since divisions e.g. with zero may throw an error

                On Error Resume Next

                percentChange = (yearlyChange / openingPrice)


                'Now we print in the summary table
                '--------------------------------------------

                'the ticker
                Range("I" & summaryTableRow).Value = tickerLabel


                'the yearly change
                Range("J" & summaryTableRow).Value = yearlyChange

                'the percent change
                Range("K" & summaryTableRow).Value = percentChange

                'the total volume
                Range("L" & summaryTableRow).Value = totalVolume


                'Prepare variables that may change in next iteration [Housekeeping!] as
                '----------------------------------------------

                 'increment summaryTableRow by 1

                summaryTableRow = summaryTableRow + 1

                'reset the total volume

                totalVolume = 0


                Else

                'add to the total volume

                totalVolume = totalVolume + Cells(i, 7).Value


                End If


        Next i ' to run the next loop

    'set value for the last row in the summary table

    
    lastSummaryRow = Cells(Rows.Count, 10).End(xlUp).Row

    For j = 2 To lastSummaryRow
    
    

        'Change the format depending on the value
            If Cells(j, 10) >= 0 Then
                Cells(j, 10).Interior.ColorIndex = 4
      
            ElseIf Cells(j, 10) < 0 Then
                Cells(j, 10).Interior.ColorIndex = 3
       
            End If
            
            'Iterate through each row and replace the greatest increase value
            If Cells(j, 11) > greatestIncrease Then
                greatestIncrease = Cells(j, 11)
                Cells(2, 17) = greatestIncrease
                Cells(2, 17).NumberFormat = "0.00%"
                Cells(2, 16) = Cells(j, 9)
       
            End If
       
            'Iterate through each row and replace the greatest decrease value
            If Cells(j, 11) < greatestDecrease Then
                greatestDecrease = Cells(j, 11)
                Cells(3, 17) = greatestDecrease
                Cells(3, 17).NumberFormat = "0.00%"
                Cells(3, 16) = Cells(j, 9)
      
            End If
            
            'Iterate through each row and replace the greatest total volume
            If Cells(j, 12) > greatestVolume Then
                greatestVolume = Cells(j, 12)
                Cells(4, 17) = greatestVolume
                Cells(4, 17).NumberFormat = "#,###"
                Cells(4, 16) = Cells(j, 9)
       
            End If

     Next j

            Columns("I:Q").AutoFit

Next ws


'Reset to defaults of the application/ Excel
Application.DisplayAlerts = True
Application.ScreenUpdating = True

End Sub
