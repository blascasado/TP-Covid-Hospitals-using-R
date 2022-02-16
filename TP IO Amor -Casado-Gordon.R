library(lpSolve)

hospitales <- read.csv("hospitales.csv")

demanda <- read.csv("demanda.csv")

dia <- demanda$dia
DR <- demanda$normal
DC <- demanda$COVID
DT <- demanda$TI

#Coeficientes del funcional
z <- c(1,1,1,2.01,2.01,2.01,3.02,3.02,3.02) 

#Coeficientes de las restricciones
A <- matrix(c(1,0,0,1/3.73,0,0,2,0,0,1,0,0,1,0,0,0,1/2.34,0,0,1.7,0,0,1,0,1,0,0,0,0,1/2.94,0,0,3,0,0,1,0,1,0,1/2,0,0,2,0,0,1,0,0,0,1,0,0,1/1.23,0,0,1.7,0,0,1,0,0,1,0,0,0,1/1.6,0,0,3,0,0,1,0,0,1,1/2,0,0,2,0,0,1,0,0,0,0,1,0,1/1.23,0,0,1.7,0,0,1,0,0,0,1,0,0,1/1.6,0,0,3,0,0,1), ncol=9 )
A <- round(A,2)

#Direccion de las restricciones
dir <- c('<=','<=','<=','<=','<=','<=','<=','<=','<=','<=','<=','<=')

#Terminos independientes restricciones (rhs)

resultado.1 <- list()
resultado.2 <- list()
resultado.4 <- list()
resultado.5 <- list()

for (dia in 1:nrow(demanda)) { 
  b <- c(demanda[dia,'normal'],demanda[dia,'COVID'],demanda[dia,'TI'],220,300,280,1266,1103,1013,800,700,750)
  solucion <- lp ('max', z , A , dir, b)
  
  round(solucion$solution,0)
  
  PR2 <- solucion$solution[1]
  PR5 <- solucion$solution[2]
  PR8 <- solucion$solution[3]
  
  PR <- PR2+PR5+PR8
  PR <- round(PR,0)
  
  PC2 <- solucion$solution[4]
  PC5 <- solucion$solution[5]
  PC8 <- solucion$solution[6]
  
  PC <- PC2+PC5+PC8
  PC <- round(PC,0)
  
  PT2 <- solucion$solution[7]
  PT5 <- solucion$solution[8]
  PT8 <- solucion$solution[9]
  
  PT <- PT2+PT5+PT8
  PT <- round(PT,0)
  resultado.1[[dia]] <- demanda[dia,'COVID']-PC
  resultado.2[[dia]] <- demanda[dia,'normal']-PR
}

#Pasamos del problema directo al problema dual

#Cambiamos la direccion de las restricciones al tener que MIN en el problema dual y al haber un cambio de dimensión ahora son 9 restricciones
dir2 <- c('>=','>=','>=','>=','>=','>=','>=','>=','>=')

#Listas para guardar los valores marginales del material en los tres hospitales para cada día
resultado.3H2 <- list()
resultado.3H5 <- list()
resultado.3H8 <- list()

#Terminos independientes restricciones (rhs)
for (dia in 1:nrow(demanda)) { 
  b <- c(demanda[dia,'normal'],demanda[dia,'COVID'],demanda[dia,'TI'],220,300,280,1266,1103,1013,800,700,750)
  #Para pasar del prblema Directo al probelma Dual trasponemos la matriz A e invertimos el orden de los vectores b y z entre sí
  solucion.dual <- lp ('min', b , t(A) , dir2, z)
  
  round(solucion.dual$solution,3)
  
  CM.MAT.2 <- solucion.dual$solution[7]
  CM.MAT.5 <- solucion.dual$solution[8]
  CM.MAT.8 <- solucion.dual$solution[9]
  
  resultado.3H2 [[dia]] <- c(CM.MAT.2)
  resultado.3H5 [[dia]] <- c(CM.MAT.5)
  resultado.3H8 [[dia]] <- c(CM.MAT.8)
}
#Resultados

cat('1) La cantidad de  pacientes con COVID que NO pueden atenderse es de', resultado.1[[5]], 'en el día 5, de', resultado.1[[60]], 'en el día 60 y de',resultado.1[[90]], 'en el día 90')

cat('2) La cantidad de  pacientes regulares que NO pueden atenderse es de', resultado.2[[5]], 'en el día 5, de', resultado.2[[60]], 'en el día 60 y de',resultado.2[[90]], 'en el día 90')

cat('3) En el día 80 pagaría por una unidad adicional de material sanitario:', resultado.3H2[[80]],'um en el H2,', resultado.3H5[[80]],'um en el H5 y',resultado.3H8[[80]],'um en el H8')

cat('4) En el día 13 colapsa el sistema de salud para los pacientes regulares al no ser atendidos', resultado.2[[13]], 'pacientes regulares')

cat('5) En el día 70 colapsa el sistema de salud para los pacientes COVID al no ser atendidos', resultado.1[[70]], 'pacientes COVID')
