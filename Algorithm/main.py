import numpy as np
import matplotlib.pyplot as plt
import os
from PIL import Image, ImageFilter
import copy

class Algorithm:

    # initializes class variables / paths
    def __init__(self, path: str, id: int) -> None:
        try:
            self.__img = Image.open(path)
            self.__path = path
            self.__id = id
            if self.getDimensions()[0] > 100 and self.getDimensions()[1] > 100:
                self.__resize()

            self.idColorMap = None
            self.idArr = self.__getIDArray()
            self.__grayscaleImage = None
            self.__grayscalePath = "grayscale " + path

        except FileNotFoundError:
            self.__img = self.__grayscaleImage = None
            print("File not found")

    def convertToGrayscale(self) -> None:
        # checks if we have a valid source image and edited image exists in current directory
        if self.__img and not os.path.isfile(self.__grayscalePath):
            if ".png" in self.__grayscalePath:
                self.__grayscaleImage = self.__img.convert("LA")  # converts png image to grayscale
            else:
                self.__grayscaleImage = self.__img.convert("L")  # converts jpeg image to grayscale

            self.__grayscaleImage.save(self.__grayscalePath)

    def showImage(self) -> None:
        try:
            plt.imshow(self.__img)
            plt.show()
        except TypeError:
            print("No image to display")

    def showEditedImage(self) -> None:
        # displays edited image if one has already been created
        try:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            plt.imshow(self.__grayscaleImage)
            plt.show()
        except TypeError:
            print("No image to display")

    def __resize(self) -> None:
        self.__img = self.__img.resize((100, 100))

    # returns 2D array where each rgb pixel is represented by a string
    def getRGB(self) -> list:
        if self.__img:  # checks for valid image
            return self.__rgb(self.__img, self.getDimensions()[0], self.getDimensions()[1])
        else:
            print("Image does not exist")

    # returns 2D array where each rgb pixel is represented by a string
    def getEditedRGB(self) -> list:
        if self.__grayscaleImage:  # checks for valid image
            return self.__rgb(self.__grayscaleImage, self.getEditedDimensions()[0], self.getEditedDimensions()[1])
        else:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            print("Edited image does not exist")

    # RGB string array helper function
    def __rgb(self, image, x: int, y: int) -> list:
        rgbArr = []
        numArr = np.array(image)  # converts image object to numpy array

        for i in range(x):
            rgbArr.append([])
            for j in range(y):
                # iterates through pixel list and makes each value a string
                pixel = [str(rgb) for rgb in np.array(numArr[i][j]).tolist()]
                rgbArr[i].append(','.join(pixel))
        return rgbArr

    # return color ID array
    def __getIDArray(self) -> list:
        if self.__img:  # checks for valid image
            return self.__getID(self.__img, self.getDimensions()[0], self.getDimensions()[1])
        else:
            print("Image does not exist")

    # return color ID array for edited image
    def getEditedIDArray(self) -> list:
        if self.__grayscaleImage:  # checks for valid image
            return self.__getID(self.__grayscaleImage, self.getEditedDimensions()[0], self.getEditedDimensions()[1])
        else:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            print("Edited image does not exist")

    # returns 2D array where each rgb pixel is represented by an id number dictating which color block it belongs to

    def getLayerNum(self, givenPixel, targets,
                    idMap, idArr):  # given list of nearby layerNums find similar ones or return new layerNum
        algo_color_range = 60
        layerNumResult = -1  # return result if it's -1, means new layer
        for i in targets:
            pixel = idMap[i][-1]
            matches = 0
            for colorLayer in range(len(pixel)):
                if abs(givenPixel[colorLayer] - pixel[colorLayer]) < algo_color_range:
                    matches += 1
            if matches == len(pixel):  # if the given pixel matches a idMap color:
                if layerNumResult == -1:  # set it to idMap LayerNum
                    layerNumResult = i
                elif layerNumResult > i:  # if Previous layerNum is bigger use the smaller one.
                    idMap[layerNumResult][0] = i  # tell layerNumResult to collapse to i
                    layerNumResult = i
                elif layerNumResult < i:  # if Previous layerNum is bigger use the smaller one.
                    idMap[i][0] = layerNumResult  # tell i to collapse to layerNumResult

        if layerNumResult == -1:  # if no matches were made give a new layerNum
            returnLen = len(idMap)
            idMap[returnLen] = [-1, givenPixel]
            return [returnLen, idMap]
        return [layerNumResult, idMap]

    def travesal(self, idMap, id):
        if idMap[id][0] == -1:
            return id
        else:
            return self.travesal(idMap, idMap[id][0])

    def collapse_refit(self, idMap, idArr):
        # Collapse
        unused_layers = []
        for id in idMap:
            if idMap[id][0] == -1:
                continue
            else:
                unused_layers.append(id)
                idMap[id][0] = self.travesal(idMap,idMap[id][0])

        # refit [0,1,2,3,4,5,6,7,8,9,10]
        # unused_layers [list of nums] (sorted Lowest to highest) [3,5,7,9]
        num_unused = len(unused_layers)
        unused_index = unused_layers.pop(0)
        end_index = len(idMap) - 1
        refited_items = {} # making sure to correct items
        while end_index > unused_index:  ## swap bigger index items to a smaller one
            if idMap[end_index][0] == -1:  ## swap only if it isn't being swapped already
                if end_index in refited_items:
                    for collapseTarget in refited_items[end_index]:
                        idMap[collapseTarget][0] = unused_index
                    del refited_items[end_index]
                idMap[end_index][0] = unused_index
                idMap[unused_index][1] = idMap[end_index][1]
                unused_index = unused_layers.pop(0)
                end_index -= 1
            else:
                if idMap[end_index][0] in refited_items:
                    refited_items[idMap[end_index][0]].append(end_index) 
                else:
                    refited_items[idMap[end_index][0]] = [end_index]
                end_index -= 1

        # Apply
        for i in range(len(idArr)):
            for j in range(len(idArr[i])):
                if idMap[idArr[i][j]][0] != -1:
                    idArr[i][j] = idMap[idArr[i][j]][0]

        # Cleanup
        dict_last_index = list(idMap.keys())[-1]
        for x in range((dict_last_index - num_unused + 1), dict_last_index + 1):
            del idMap[x]
        return [idMap, idArr]
    #Testing functions
    def targetScan(self,idArr,target):
        for i in range(len(idArr)):
            for j in range(len(idArr[i])):
                if idArr[i][j] == target: 
                    return [i,j]
        return False
    def idMapScan(self,idMap):
        for i in idMap:
            print(i,idMap[i][0])
    def idMapCompare(self,idMap,idMap2):
        for i in idMap:
            if idMap[i][0] != idMap2[i][0]:
                print(i,":",idMap[i][0],"vs",idMap2[i][0])
    # returns 2D array where each rgb pixel is represented by an id number dictating which color block it belongs to
    def __getID(self, image, x: int, y: int) -> list:
        numArr = np.array(image)  # converts image object to numpy array
        idArr = []
        idMap = {
            # 0: [-1,[0, 0, 0, 0]],  # jpeg is length 3 while png is length 4
            # 1: [-1,[0, 0, 0, 255]],  # outline of image (for black solid outline though)
        }
        for i in range(x):
            idArr.append([])  # append new row
            for j in range(y):
                pixel = np.array(numArr[i][j]).tolist()

                [layer_num, idMap] = self.getLayerNum(pixel, self.getNeighbors(i, j, idArr), idMap, idArr)
                idArr[i].append(layer_num)  # append new column pixel

        self.collapse_refit(idMap, idArr)
        self.idColorMap = idMap
        return idArr

    def getNeighbors(self, i, j, arr):
        neighbors = []
        x = len(arr[0])

        if j > 0:
            neighbors.append(arr[i][j - 1])
        if i > 0:
            neighbors.append(arr[i - 1][j])
            if j > 0:
                neighbors.append(arr[i - 1][j - 1])
            if j < x - 1:
                neighbors.append(arr[i - 1][j + 1])
        return neighbors

    def getDimensions(self) -> tuple:
        if self.__img:
            return np.array(self.__img).shape
        else:
            print("Image does not exist")

    def getEditedDimensions(self) -> tuple:
        if self.__grayscaleImage:
            return np.array(self.__grayscaleImage).shape
        else:
            # self.convertToGrayscale()   # creates modifiable image if it doesn't already exist
            print("Edited image does not exist")

    # so far only displays outer edge
    def showOutline(self) -> None:
        edge = self.__img.filter(ImageFilter.FIND_EDGES)
        plt.imshow(edge)
        plt.show()

    def deleteEditedImage(self) -> None:
        try:
            os.remove(self.__grayscalePath)
            self.__grayscaleImage = None
            print("Image deleted")
        except FileNotFoundError:
            print(f"Could not find the file {self.__grayscalePath} to delete")

    def updateExport(self) -> None:  # Clear files and export
        self.purgeSaved()
        self.export()

    def purgeSaved(self) -> None:  # Clear files
        directory = "./exports/" + str(self.__id)
        if os.path.isdir(directory):
            if os.path.isfile(directory + "/title.txt"):
                os.remove(directory + "/title.txt")
            if os.path.isfile(directory + "/column.txt"):
                os.remove(directory + "/column.txt")
            if os.path.isfile(directory + "/row.txt"):
                os.remove(directory + "/row.txt")
            if os.path.isfile(directory + "/layerMatrix.txt"):
                os.remove(directory + "/layerMatrix.txt")
            if os.path.isfile(directory + "/colorMap.txt"):
                os.remove(directory + "/colorMap.txt")
            if os.path.isfile(directory + "/numLayer.txt"):
                os.remove(directory + "/numLayer.txt")

    def export(self) -> None:  # Export files and create directory
        directory = "./exports/" + str(self.__id)
        try:
            os.makedirs(directory)
        except OSError:
            if not os.path.isdir(directory):
                raise
        self.saveTitleTxt()
        self.saveRowTxt()
        self.saveColumnTxt()
        self.saveidArrTxt()
        self.saveidColorMapTxt()
        self.saveNumLayerTxt()

    def saveTitleTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/title.txt"
        if not os.path.isfile(txtFile):
            with open(txtFile, "w") as appen:
                appen.write(str(self.__path.split(".")[-1].split("/")[-1]))

    def saveColumnTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/column.txt"
        if not os.path.isfile(txtFile):
            with open(txtFile, "w") as appen:
                appen.write(str(self.getDimensions()[1]))

    def saveRowTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/row.txt"
        if not os.path.isfile(txtFile):
            with open(txtFile, "w") as appen:
                appen.write(str(self.getDimensions()[0]))

    def saveidArrTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/layerMatrix.txt"
        if not os.path.isfile(txtFile):
            np.savetxt(txtFile, np.array(self.idArr), fmt="%d", delimiter=",")

    def saveidColorMapTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/colorMap.txt"
        if not os.path.isfile(txtFile):
            for target, values in self.idColorMap.items():
                a = np.array(values[1])
                with open(txtFile, "ab") as appen:
                    np.savetxt(appen, a.reshape(1, a.shape[0]), fmt="%d", delimiter=",")

    def saveNumLayerTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/numLayer.txt"
        if not os.path.isfile(txtFile):
            with open(txtFile, "w") as appen:
                appen.write(str(len(self.idColorMap)))

    # convert id array back to image object readable by pillow
    def idToRGB(self) -> np.ndarray:
        convertedID = []
        idArr = self.__getIDArray()
        for i in range(len(idArr)):
            convertedID.append([])
            for j in range(len(idArr[i])):
                convertedID[i].append(self.idColorMap[idArr[i][j]][1])
        return np.array(convertedID)

    # returns color has map with color ID and their corresponding pixel(rgb) list
    def getColorMap(self) -> dict:
        return self.idColorMap


ball = Algorithm("./ball.jpg", 3)
ball.export()
plt.imshow(ball.idToRGB())
plt.show()


'''
# Get product names that were done before
items = []
with open("items.txt", "r") as f:
  for line in f:
    items.append(line.strip())
print("Items List:", items)

# images to convert
targets = os.listdir("./Images")
print("Pictures List:", targets)

# Target size
# widthInput = 100
# HeightInput = 100

# Controls
itemUpdate = False #Update existing item
itemExists = False #Item has been processed name-wise before

print("Beginning Exporting:")
# Start
for target in targets:
    try:
        tempInt = int(items.index(target))
        itemExists = True
        print("<>" + target, "Exists in items.txt")
    except ValueError:
        tempInt = int(len(items))
        items.append(target)
        itemExists = False

    if itemUpdate: # Export all images
        print("<>Exporting:", target)
        temp = Algorithm("./Images/"+target, tempInt)
        temp.updateExport()
    elif not itemExists: # Only new images get exported
        print("<>Exporting:", target)
        temp = Algorithm("./Images/"+target, tempInt)
        temp.updateExport()
print("Exporting Completed")


# Remember finished products
print("End List:", items)
with open("items.txt", "w") as f:
    for s in items:
        f.write(str(s) +"\n")
'''