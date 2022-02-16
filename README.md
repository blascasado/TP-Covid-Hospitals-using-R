# TP-Covid-Hospitals-using-R
Final Project of Operations Research course @UBA as part of my Engineering degree

You may find attached the final document (https://github.com/blascasado/TP-Covid-Hospitals-using-R/blob/main/TP%20Obligatorio%20Investigaci%C3%B3n%20Operativa%2071.pdf), the R language code used (https://github.com/blascasado/TP-Covid-Hospitals-using-R/blob/main/TP%20IO%20Amor%20-Casado-Gordon.R) and de csv. files () necessary to run it.

The main objective of this project was to optimize the hospoitals resources as to assist the best number of patients and identify when the intensive care unit beds will be at 100% occupancy considering the forecasted demand.

The SIMPLEX method learnt during the Operations Reasearch course was used to optimize this problem. The problem consisted of 9 variables: three group of patients (Regular, COVID and intense care) multiplied by the 3 different hospitals. These variables were conditioned in the problem by 12 restrictions: #beds, #doctors, #medical_kits and the forecasted demand of #patients, these 4 restrictions are multiplied by the 3 group of patients mentioned before.
