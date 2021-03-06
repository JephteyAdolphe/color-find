import numpy as np
import matplotlib.pyplot as plt
import os
from PIL import Image, ImageFilter
import copy
import cv2
from sklearn.cluster import MiniBatchKMeans
import time
# from prettytable import PrettyTable # python -m pip install -U prettytable

#First version with Kmeans (Est T(kmean + idMap))
class Algorithm_v1:

    # initializes class variables / paths
    def __init__(self, path: str, id: int, width=200, height=200, kvalue = 3, BW_enable = True) -> None:
        try:
            self.k = kvalue
            self.__img = self.kmeans(path,height,width)
            self.__path = path
            self.__id = id
            self.__width = width  # default 50
            self.__height = height  # default 50
            # self.__resize(height, width)

            self.idColorMap = None
            self.idArr = self.__getIDArray()
            self.__grayscaleImage = None
            self.__grayscalePath = "grayscale " + path

        except FileNotFoundError:
            self.__img = self.__grayscaleImage = None
            print("File not found")

    def canny(self):
        plt.subplot(121), plt.imshow(img, cmap='gray')
        plt.title('Original Image'), plt.xticks([]), plt.yticks([])
        plt.subplot(122), plt.imshow(edges, cmap='gray')
        plt.title('Edge Image'), plt.xticks([]), plt.yticks([])
        plt.show()

    def kmeans(self, path, height, width):
        # load the image and grab its width and height
        image = cv2.imread(path)
        image = cv2.resize(image, (height, width), interpolation=cv2.INTER_NEAREST)
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
        clt = MiniBatchKMeans(n_clusters=self.k)
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
        # cv2.imshow(path, np.hstack([image, quant]))
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

    def __resize(self, height, width) -> None:
        self.__img = self.__img.resize((height, width))

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
    def __getID(self, image, x: int, y: int) -> list:
        numArr = np.array(image)  # converts image object to numpy array
        idArr = []
        idMap = {
            # 0: [0, 0, 0, 0],  # jpeg is length 3 while png is length 4
            # 1: [0, 0, 0, 255],  # outline of image (for black solid outline though)
        }

        for i in range(x):
            idArr.append([])
            for j in range(y):
                pixel = np.array(numArr[i][j]).tolist()

                if list(idMap):
                    if self.__getIDHelper(idMap, pixel) is not None:
                        idArr[i].append(self.__getIDHelper(idMap, pixel))
                    else:
                        # new color has been visited -> create new ID
                        newID = list(idMap)[-1] + 1
                        idMap[newID] = pixel
                        idArr[i].append(newID)
                else:
                    idMap[0] = pixel
                    idArr[i].append(0)

        self.idColorMap = idMap
        return idArr

    # gets ID for visited pixel
    def __getIDHelper(self, idMap: dict, pixelToCheck: list) -> int:
        for colorID in idMap:
            matches = 0
            for i in range(len(pixelToCheck)):
                # checks to see if any rgb value pairs differ by 20 or more
                if abs(pixelToCheck[i] - idMap[colorID][i]) < 60:
                    matches += 1
            if matches == len(pixelToCheck):
                return colorID
        return None

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
                appen.write(str(self.getDimensions()[1]))

    def saveRowTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/row.txt"
        if not os.path.isfile(txtFile):
            with open(txtFile, "w") as appen:
                appen.write(str(self.getDimensions()[0]))

    def saveidArrTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/layerMatrix.txt"
        if not os.path.isfile(txtFile):
            np.savetxt(txtFile, np.array(self.idArr), fmt="%d", delimiter=",", newline=',')

    def saveidColorMapTxt(self) -> None:
        txtFile = "./exports/" + str(self.__id) + "/colorMap.txt"
        if not os.path.isfile(txtFile):
            for target, values in self.idColorMap.items():
                a = np.array(values)
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
                convertedID[i].append(self.idColorMap[idArr[i][j]])
        return np.array(convertedID)

    # returns color has map with color ID and their corresponding pixel(rgb) list
    def getColorMap(self) -> dict:
        return self.idColorMap