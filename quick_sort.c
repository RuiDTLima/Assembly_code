#include <stdio.h>
#include <string.h>
/*=======================================================================*/
int compare (const void *left, const void *right);

static void memswap(void *one, void *other, size_t width);

void quick_sort(void *base, size_t nel, size_t width,int (*compar)(const void *, const void *)) ;

/*=======================================================================*/
int main(){
	int n;
    int values[] = { 88, 56, 100, 2, 25 };
    printf("Before sorting the list is: \n");
    for( n = 0 ; n < 5; n++ ) {
        printf("%d ", values[n]);
    }
    quick_sort(&values, 5, sizeof(int), &compare);
    printf("\nAfter sorting the list is: \n");
    for( n = 0 ; n < 5; n++ ) {
        printf("%d \n", values[n]);
    }
    return 0;
}

/*=======================================================================*/
int compare(const void *left, const void *right){
    return (*(int*)left)-(*(int*)right);
}

/*=======================================================================*/
/*static void memswap(void *one, void *other, size_t width) {
	char tmp[width];
	memcpy(tmp, one, width);
	memcpy(one, other, width);
	memcpy(other, tmp, width);
}*/

/*=======================================================================*/
/*void quick_sort(void *base, size_t nel, size_t width,int (*compar)(const void *, const void *)) {
	void *last = base + width * (nel - 1), *right = last;
	void *left = base + width;
	/* we consider the leftmost array element as pivot! */
	
	/*do {
		while (left <= right && (*compar)(left, base) <= 0)
		left += width;
		while (right >= left && (*compar)(right, base) >= 0)
		right -= width;
		if (right < left)
		break;
		memswap(left, right, width);
	} while (1);
	memswap(base, right, width);
	
	/* right defines the split point */
	
	/*if (right > base)
	quick_sort(base, (right - base) / width, width, compar);
	if (right < last)
	quick_sort(right + width, (last - right) / width, width, compar);
}*/
