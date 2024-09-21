#include "label.h"

#define LABEL_REF_LIST_SIZE 20

label labelList[LABEL_REF_LIST_SIZE];
reference referenceList[LABEL_REF_LIST_SIZE];

int currentLabelIndex = 0, currentRefIndex = 0;

int addLabel(label add)
{
    if (currentLabelIndex >= LABEL_REF_LIST_SIZE)
    {
        return -1;
    }

    labelList[currentLabelIndex] = add;
    currentLabelIndex++;

    devlogf("added label\n");
    return currentLabelIndex;
}

int addRef(reference add)
{
    if (currentRefIndex >= LABEL_REF_LIST_SIZE)
    {
        return -1;
    }

    referenceList[currentRefIndex] = add;
    currentRefIndex++;

    devlogf("added reference\n");
    return currentRefIndex;
}

label *searchLabel(char *refName)
{
    for (int i = 0; i < currentLabelIndex; i++)
    {
        /* code */
        if (strcmp(labelList[i].labelname, refName) == 0)
        {
            return &(labelList[i]);
        }

        printf("%d, %s", labelList[i].address, labelList[i].labelname);
    }
    return NULL;
}

void freeLabelRef()
{
    // label
    for (int i = 0; i < currentLabelIndex; i++)
    {
        free(labelList[i].labelname);
    }

    // ref
    for (int i = 0; i < currentRefIndex; i++)
    {
        free(referenceList[i].labelname);
    }

    return;
}
