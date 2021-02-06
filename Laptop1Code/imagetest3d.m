%[TR,fileformat,attributes,solidID] = stlread('Rocket.stl');
model = createpde(3);
importGeometry(model,'Rocket.stl');
pdegplot(model)