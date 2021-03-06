import numpy as np
import matplotlib.pyplot as plt
import os
from PIL import Image, ImageFilter
import copy
import cv2
from sklearn.cluster import MiniBatchKMeans
import time
# from prettytable import PrettyTable # python -m pip install -U prettytable

# inefficient version of Algo v2  (Est T(kmean + idArr*idMap + 2idArr + 3idMap ))
class Algorithm_v2_old:

    # initializes class variables / paths
    def __init__(self, path: str, id: int, width=200, height=200, kvalue=3, BW_enable=True) -> None:
        try:
            self.__img = self.kmeans(path, height, width, kvalue)
            self.__path = path
            self.__id = id
            self.__width = width  # default 200
            self.__height = height  # default 200
            self.__BW_enable = BW_enable

            self.idColorMap = None
            self.idArr = self.__getIDArray()
            self.__grayscaleImage = None
            self.__grayscalePath = "grayscale " + path

        except FileNotFoundError:
            self.__img = self.__grayscaleImage = None
            print("File not found")

    def kmeans(self, path, height, width, kvalue=5):

        # load the image and grab its width and height
        image = cv2.imread(path)
        image = cv2.resize(image, (height - 1, width - 1), interpolation=cv2.INTER_NEAREST)
        bColor = [int(image[0][0][0]), int(image[0][0][1]), int(image[0][0][2])]
        image = cv2.copyMakeBorder(image, 1, 1, 1, 1, cv2.BORDER_CONSTANT, value=bColor)
        (h, w) = image.shape[:2]
        # convert the image from the RGB color space to the L*a*b*
        # color space -- since we will be clustering using k-means
        # which is based on the euclidean distance, we'll use the
        # L*a*b* color space where the euclidean distance implies
        # perceptual meaning
        image = cv2.cvtColor(image, cv2.COLOR_BGR2LAB)
        # reshape the image into a feature vector so that k-means
        # can be applied
        image = image.reshape((image.shape[0] * image.shape[1], 3))
        # apply k-means using the specified number of clusters and
        # then create the quantized image based on the predictions
        clt = MiniBatchKMeans(n_clusters=kvalue)
        labels = clt.fit_predict(image)
        quant = clt.cluster_centers_.astype("uint8")[labels]
        # reshape the feature vectors to images
        quant = quant.reshape((h, w, 3))
        image = image.reshape((h, w, 3))
        # convert from L*a*b* to RGB
        quant = cv2.cvtColor(quant, cv2.COLOR_LAB2BGR)
        image = cv2.cvtColor(image, cv2.COLOR_LAB2BGR)
        img = cv2.cvtColor(quant, cv2.COLOR_BGR2RGB)
        # display the images and wait for a keypress
        # cv2.imshow("ball.jpg", np.hstack([quant]))
        # plt.imshow(img)
        # plt.show()
        # cv2.waitKey(0)

        return Image.fromarray(img)

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
        self.__img = self.__img.resize((500, 500))

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

    def collapse_near(self, idMap, idArr, id):  # convert to nearest one that isn't itself
        for i in range(len(idArr)):
            for j in range(len(idArr[i])):
                if idArr[i][j] == id:  # check neighbors for different colors
                    if i == 0 and j == 0:
                        idMap[id][0] = self.unrelated(id,
                                                      [idArr[i + 1][j], idArr[i][j + 1], idArr[i + 1][j + 1]])
                        if idMap[id][0] != -1:
                            return idMap
                    elif i == 0 and j == len(idArr[i]) - 1:
                        idMap[id][0] = self.unrelated(id,
                                                      [idArr[i][j - 1], idArr[i + 1][j - 1], idArr[i + 1][j]])
                        if idMap[id][0] != -1:
                            return idMap
                    elif i == len(idArr) - 1 and j == 0:
                        idMap[id][0] = self.unrelated(id,
                                                      [idArr[i - 1][j], idArr[i - 1][j + 1], idArr[i][j + 1]])
                        if idMap[id][0] != -1:
                            return idMap
                    elif i == len(idArr) - 1 and j == len(idArr[i]) - 1:
                        idMap[id][0] = self.unrelated(id,
                                                      [idArr[i - 1][j - 1], idArr[i][j - 1], idArr[i - 1][j]])
                        if idMap[id][0] != -1:
                            return idMap
                    elif i == 0:
                        idMap[id][0] = self.unrelated(id,
                                                      [idArr[i][j - 1], idArr[i + 1][j - 1], idArr[i + 1][j],
                                                       idArr[i][j + 1], idArr[i + 1][j + 1]])
                        if idMap[id][0] != -1:
                            return idMap
                    elif j == 0:
                        idMap[id][0] = self.unrelated(id,
                                                      [idArr[i - 1][j], idArr[i + 1][j],
                                                       idArr[i - 1][j + 1], idArr[i][j + 1], idArr[i + 1][j + 1]])
                        if idMap[id][0] != -1:
                            return idMap
                    elif i == len(idArr) - 1:
                        idMap[id][0] = self.unrelated(id,
                                                      [idArr[i - 1][j - 1], idArr[i][j - 1],
                                                       idArr[i - 1][j], idArr[i - 1][j + 1], idArr[i][j + 1]])
                        if idMap[id][0] != -1:
                            return idMap
                    elif j == len(idArr[i]) - 1:
                        idMap[id][0] = self.unrelated(id,
                                                      [idArr[i - 1][j - 1], idArr[i][j - 1], idArr[i + 1][j - 1],
                                                       idArr[i - 1][j], idArr[i + 1][j]])
                        if idMap[id][0] != -1:
                            return idMap
                    else:
                        idMap[id][0] = self.unrelated(id,
                                                      [idArr[i - 1][j - 1], idArr[i][j - 1], idArr[i + 1][j - 1],
                                                       idArr[i - 1][j], idArr[i + 1][j],
                                                       idArr[i - 1][j + 1], idArr[i][j + 1], idArr[i + 1][j + 1]])
                        if idMap[id][0] != -1:
                            return idMap

        return idMap

    def unrelated(self, id, ids):
        for x in ids:
            if id != x:
                return x
        return -1

    def collapse_refit(self, idMap, idArr):
        minimal = int(len(idArr) / 10)
        if minimal < 10:
            minimal = 10
        # Collapse
        unused_layers = []
        for id in idMap:  # make sure all layers converts to a layer that goes to -1
            if idMap[id][0] == -1:  # if already go to -1 continue and keep layer
                if idMap[id][2] < minimal:  # layers with only small amount of pixels get pushed out
                    idMap = self.collapse_near(idMap, idArr, id)
                    unused_layers.append(id)
                    idMap[id][0] = self.travesal(idMap, idMap[id][0])
                else:
                    continue
            else:  # else it is unsused and will be converted later
                unused_layers.append(id)
                idMap[id][0] = self.travesal(idMap, idMap[id][0])

        # refit [0,1,2,3,4,5,6,7,8,9,10]
        # unused_layers [list of nums] (sorted Lowest to highest) [3,5,7,9]
        num_unused = len(unused_layers)
        unused_index = unused_layers.pop(0)
        end_index = len(idMap) - 1
        refited_items = {}  # making sure to correct items
        while end_index > unused_index:  # swap bigger index items to a smaller one
            if idMap[end_index][0] == -1:  # swap only if it isn't being swapped already
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
                    idArr[i][j] = idMap[idArr[i][j]][0]  # replace numbers in the idArr

        # Cleanup
        dict_last_index = list(idMap.keys())[-1]  # delete unused layering numbers
        for x in range((dict_last_index - num_unused + 1), dict_last_index + 1):
            del idMap[x]
        return [idMap, idArr]

    # Testing functions
    def targetScan(self, idArr, target):
        for i in range(len(idArr)):
            for j in range(len(idArr[i])):
                if idArr[i][j] == target:
                    return [i, j]
        return False

    def idMapScan(self, idMap):
        for i in idMap:
            print(i, idMap[i][0])

    def idMapCompare(self, idMap, idMap2):
        for i in idMap:
            if idMap[i][0] != idMap2[i][0]:
                print(i, ":", idMap[i][0], "vs", idMap2[i][0])

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

                [layer_num, idMap] = self.getLayerNum(pixel, self.getNeighbors(i, j, idArr), idMap, idArr,
                                                      self.__BW_enable)
                idArr[i].append(layer_num)  # append new column pixel

        [idMap, idArr] = self.collapse_refit(idMap, idArr)
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

    def getLayerNum(self, givenPixel, targets,
                    idMap, idArr,
                    B_W_enable=False):  # given list of nearby layerNums find similar ones or return new layerNum
        algo_color_range = 40
        white_black_temp = -1
        algo_black_range = 5
        B_W_bound_range = 85
        if B_W_enable:
            if (abs(givenPixel[0] - givenPixel[1]) < algo_black_range):  # check for greys/blacks/whites zones
                if (abs(givenPixel[1] - givenPixel[2]) < algo_black_range):
                    if (abs(givenPixel[0] - givenPixel[2]) < algo_black_range):
                        if (givenPixel[0] < B_W_bound_range):
                            white_black_temp = 0  # low extreme
                        elif (givenPixel[0] < 255 - B_W_bound_range):
                            white_black_temp = 1  # high extreme
                        else:
                            white_black_temp = 2  # grey
        layerNumResult = -1  # return result if it's -1, means new layer
        for i in targets:
            pixel = idMap[i][1]
            matches = 0
            if B_W_enable:
                if layerNumResult == -1:
                    if white_black_temp > -1:
                        if white_black_temp == idMap[i][3]:
                            layerNumResult = i
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
            idMap[returnLen] = [-1, givenPixel, 1, white_black_temp]
            return [returnLen, idMap]
        idMap[layerNumResult][2] += 1
        return [layerNumResult, idMap]

    def travesal(self, idMap, id):  # crawling down to find target with -1 convert value
        if idMap[id][0] == -1:
            return id
        else:
            return self.travesal(idMap, idMap[id][0])

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
                appen.write(str(self.__path.split("/")[-1].split(".")[0]))

    def saveColumnTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/column.txt"
        if not os.path.isfile(txtFile):
            with open(txtFile, "w") as appen:
                appen.write(str(self.__width))

    def saveRowTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/row.txt"
        if not os.path.isfile(txtFile):
            with open(txtFile, "w") as appen:
                appen.write(str(self.__height))

    def saveidArrTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/layerMatrix.txt"
        if not os.path.isfile(txtFile):
            np.savetxt(txtFile, np.array(self.idArr), fmt="%d", delimiter=",")

    def saveidColorMapTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/colorMap.txt"
        if not os.path.isfile(txtFile):
            for _, values in self.idColorMap.items():
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