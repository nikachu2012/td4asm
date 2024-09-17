#include "label.h"

#define LABEL_REF_LIST_SIZE 20

label *labelList[LABEL_REF_LIST_SIZE];
reference *referenceList[LABEL_REF_LIST_SIZE];

int currentLabelIndex = 0, currentRefIndex = 0;

int addLabel(label *add)
{
    if (currentLabelIndex >= LABEL_REF_LIST_SIZE)
    {
        return -1;
    }

    labelList[currentLabelIndex] = add;
    currentLabelIndex++;

    return currentLabelIndex;
}

int addRef(reference *add)
{
    if (currentRefIndex >= LABEL_REF_LIST_SIZE)
    {
        return -1;
    }

    referenceList[currentRefIndex] = add;
    currentRefIndex++;

    return currentRefIndex;
}
