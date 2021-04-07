import numpy as np
import matplotlib.pyplot as plt
import os
import time
import algo_v1
import algo_v1_old
import algo_v2_old

def normalRun(Algorithm, itemUpdate = True, BW_enable = True, kmeansDefault = 5, imageShow = False):
    # itemUpdate    : Update existing item
    # BW_enable     : Special condition to attempt to merge similar greys/blacks/whites together
    # kmeansDefault : Default kmeans value
    # imageShow     : Show results visually, currently only does 1 image at a time


    # Get product names that were done before
    items = []
    with open("items.txt", "r") as f:
        for line in f:
            items.append(line.strip())
    print("Items List:", items)

    # images to convert
    targets = os.listdir("./Images")
    print("Pictures List:", targets)

    # images' kvalues
    kvalues = {}
    with open("kvalues.txt", "r") as f:
        for line in f:
            temp = line.strip().split(",")
            kvalues[temp[0]] = temp[1]
    print("kvalues List:", kvalues)

    # Target size
    sizes = []
    with open("resizeTarget.txt", "r") as f:
        for line in f:
            sizes.append(line.strip())
    print("resizeTarget:", sizes)

    print("Beginning Exporting:")
    imgNum = 0
    fig = plt.figure()
    rows = len(targets)
    times = {}
    # Start
    itemExists = False # Item has been processed name-wise before
    for target in targets:
        startTime = time.time()
        imgNum += 1
        try:
            tempInt = int(items.index(target))
            itemExists = True
            print("<>" + target, "Exists in items.txt")
        except ValueError:
            tempInt = int(len(items))
            items.append(target)
            itemExists = False

        if itemUpdate: # Export all images
            ktemp = kmeansDefault
            try:
                ktemp = int(kvalues[target])
            except KeyError:
                print("couldn't find Kvalue for",target)
            print("<>Exporting:", target)
            temp = Algorithm("./Images/"+target, tempInt, int(sizes[0]), int(sizes[1]), ktemp, BW_enable)
            temp.updateExport()
            if imageShow:
                fig.add_subplot(rows,1,imgNum)
                plt.imshow(temp.idToRGB())
                plt.show()
        elif not itemExists: # Only new images get exported
            ktemp = 5
            try:
                ktemp = int(kvalues[target])
            except KeyError:
                print("couldn't find Kvalue for",target)
            print("<>Exporting:", target)
            temp = Algorithm("./Images/"+target, tempInt, int(sizes[0]), int(sizes[1]), ktemp, BW_enable)
            temp.updateExport()
            if imageShow:
                fig.add_subplot(rows,1,imgNum)
                plt.imshow(temp.idToRGB())
                plt.show()
        timeSpent = time.time()-startTime
        print(target,"took",timeSpent,"seconds")
        times[target] = timeSpent
    print("Exporting Completed")
    #fig,show()

    # Remember finished products
    print("End List:", items)
    with open("items.txt", "w") as f:
        for s in items:
            f.write(str(s) +"\n")

    return times # return time taken on each picture if needed

def results_of_algorithm(Algorithm, trials = 1):
    data = []
    for i in range(trials):
        data.append(normalRun(Algorithm, itemUpdate = True, BW_enable = True, kmeansDefault = 5, imageShow = False))
    results = {}
    for i in range(trials):
        for target in data[i]:
            if target in results: # if item isn't there make it
                results[target] += data[i][target]
            else:
                results[target] = data[i][target]
    for x in results:
        results[x] = results[x]/trials
    return results

'''
ball = Algorithm_v2("./ball.jpg", 5, 200, 200, 3, True)
ball.updateExport()
plt.imshow(ball.idToRGB())
plt.show()
'''
# normalRun(Algorithm_v2, itemUpdate = True, BW_enable = True, kmeansDefault = 5, imageShow = False)
'''
trialx = 25
results1 = results_of_algorithm(Algorithm_v1_old,   trials= trialx)
results2 = results_of_algorithm(Algorithm_v1,       trials= trialx)
results3 = results_of_algorithm(Algorithm_v2_old,   trials= trialx)
results4 = results_of_algorithm(Algorithm_v2,       trials= trialx)
summaryTable = PrettyTable()
summaryTable.field_names = ["target","Algorithm v1 Old", "Algorithm v1", "Algorithm v2 Old", "Algorithm v2"]
for target in results1:
    summaryTable.add_row([str(target),results1[target],results2[target],results3[target],results4[target]])
print("Average Time per Algorithm for each image:")
print(summaryTable)
'''