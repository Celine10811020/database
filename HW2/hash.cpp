#include <iostream>
#include <vector>
#include <fstream>
#include <algorithm>
#include <cmath>
#include "hash.h"
#include <bitset>
#include "utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

#define NUMBER 1048576

using namespace std;

//yong key qu zou er jin wei, dio bucket

void initial();
void keyToValue(int key);

int info[2]; //0: global depth
int directory[NUMBER]; //index: the index of directory, value: point to the bucket
int bucket[NUMBER][6] = {}; //0: local depth, 1: storage status(0: mei cun dong xi, 1: jin cun yi bi zi liao, 2: man le), 2-3: key-value, 4-5: key-value
int result[2]; //0: value, 1:depth

hash_entry::hash_entry(int key, int value){
  printf("\t\t14\n");
}

hash_bucket::hash_bucket(int hash_key, int depth){
  printf("\t\t18\n");
}

/* Free the memory alocated to this->first
*/
void hash_bucket::clear(){
  printf("\t\t24\n");
}

hash_table::hash_table(int table_size, int bucket_size, int num_rows, vector<int> key, vector<int> value) //1
{
  printf("  hash_table\n");

  int i;

  printf("\ttable_size: %d\n\tbucket_size: %d\n\tnum_rows: %d\n\n", table_size, bucket_size, num_rows);

  //chu shi hua hash table
  initial();

  printf("\n");
  for(i=0; i<num_rows; i++)
  {
    //printf("\t%d, %d\n", key[i], value[i]);
    insert(key[i], value[i]);
  }
}

void initial()
{
  info[0] = 1;

  directory[0] = 0;
  directory[1] = 1;

  bucket[0][0] = 1;
  bucket[1][0] = 1;
}

/* When insert collide happened, it needs to do rehash and distribute the entries in the bucket.
** Furthermore, if the global depth equals to the local depth, you need to extend the table size.
*/
void hash_table::extend(hash_bucket *bucket){
  printf("\t\t52\n");
}

/* When construct hash_table you can call insert() in the for loop for each key-value pair.
*/
void hash_table::insert(int key, int value)
{
  //printf("  insert\n");

  int i, temp, tempOne, tempTwo;
  int index, pointer, status;
  int start;
  int keyTempOne, keyTempTwo, valueTempOne, valueTempTwo;

  index = key & ((1 << info[0]) - 1);

  //printf("\tkey: %d, value: %d, index: %d\n", key, value, index);

  pointer = directory[index];

  status = bucket[pointer][1];

  //printf("\t\tpointer: %d\n", pointer);

  //debug
  /*start = pow(2, info[0]);
  for(i=0; i<start; i++)
  {
    printf("%d %d\n", i, directory[i]);
  }*/

  //pause
  //fgetc(stdin);

  if(status == 0)
  {
    //printf("\t\tbucket_%d is empty\n", pointer);

    bucket[pointer][2] = key;
    bucket[pointer][3] = value;

    bucket[pointer][1] = 1;
  }else if(status == 1)
  {
    //printf("\t\tbucket_%d has one data\n", pointer);

    if(key == bucket[pointer][2])
    {
      bucket[pointer][3] = value;
    }else
    {
      bucket[pointer][4] = key;
      bucket[pointer][5] = value;

      bucket[pointer][1] = 2;
    }
  }else
  {
    //printf("\t\tbucket_%d has two data\n", pointer);

    if(key == bucket[pointer][2])
    {
      bucket[pointer][3] = value;
    }else if(key == bucket[pointer][4])
    {
      bucket[pointer][5] = value;
    }else
    {
      if(bucket[pointer][0] < info[0])
      {
        //printf("\t\t\tlocal depth(%d) < global depth(%d)\n", bucket[pointer][0], info[0]);

        start = pow(2, bucket[pointer][0]);
        start = start + pointer;

        directory[start] = start;

        bucket[pointer][0]++;
        bucket[start][0] = bucket[pointer][0];

        temp = pow(2, info[0]);

        for(i=0; i<temp; i++)
        {
          tempOne = i & ((1 << bucket[pointer][0]) - 1);

          if(pointer == tempOne)
          {
            directory[i] = directory[pointer];
          }else if(start == tempOne)
          {
            directory[i] = directory[start];
          }
        }

        keyTempOne = bucket[pointer][2];
        valueTempOne = bucket[pointer][3];
        keyTempTwo = bucket[pointer][4];
        valueTempTwo = bucket[pointer][5];

        bucket[pointer][1] = 0;

        insert(key, value);
        insert(keyTempOne, valueTempOne);
        insert(keyTempTwo, valueTempTwo);
      }else
      {
        //printf("\t\t\tlocal depth == global depth\n");

        info[0]++;
        bucket[pointer][0]++;

        start = pow(2, info[0]-1);

        //jiang directory size * 2, ran hou zhi xian ta men dui ying de bucket
        for(i=start; i<2*start; i++)
        {
          if(i == start+pointer)
          {
            directory[i] = i;
            bucket[i][0] = bucket[pointer][0];
          }else
          {
            directory[i] = directory[i-start];
          }
        }

        keyTempOne = bucket[pointer][2];
        valueTempOne = bucket[pointer][3];
        keyTempTwo = bucket[pointer][4];
        valueTempTwo = bucket[pointer][5];

        bucket[pointer][1] = 0;

        insert(key, value);
        insert(keyTempOne, valueTempOne);
        insert(keyTempTwo, valueTempTwo);
      }
    }
  }
}

/* The function might be called when shrink happened.
** Check whether the table necessory need the current size of table, or half the size of table
*/
void hash_table::half_table(){
  printf("\t\t65\n");
}

/* If a bucket with no entries, it need to check whether the pair hash index bucket
** is in the same local depth. If true, then merge the two bucket and reassign all the
** related hash index. Or, keep the bucket in the same local depth and wait until the bucket
** with pair hash index comes to the same local depth.
*/
void hash_table::shrink(hash_bucket *bucket){
  printf("\t\t74\n");
}

/* When executing remove_query you can call remove() in the for loop for each key.
*/
void hash_table::remove(int key){
  printf("\t\t80\n");
}

void hash_table::key_query(vector<int> query_keys, string file_name) //2, 4
{
  printf("  key_query\n");

  int i;
  int size;
  FILE *output;

  size = query_keys.size();

  //printf("size: %d\n", size);

  output = fopen("key_query_out1.txt", "w");

  for(i=0; i<size; i++)
  {
    //printf("%d\n", query_keys[i]);
    keyToValue(query_keys[i]);
    fprintf(output, "%d,%d\n", result[0], result[1]);
  }

  fclose(output);
}

void keyToValue(int key)
{
  int index, pointer;

  index = key & ((1 << info[0]) - 1);
  pointer = directory[index];

  if(key == bucket[pointer][2])
  {
    result[0] = bucket[pointer][3];
    result[1] = bucket[pointer][0];
  }else if(key == bucket[pointer][4])
  {
    result[0] = bucket[pointer][5];
    result[1] = bucket[pointer][0];
  }else
  {
    result[0] = -1;
    result[1] = bucket[pointer][0];
  }
}

void hash_table::remove_query(vector<int> query_keys){ //3
  printf("\t\t88\n");
}

/* Free the memory that you have allocated in this program
*/
void hash_table::clear(){ //5
  printf("\t\t94\n");
}
