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
int check();

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
  int size, status;
  FILE *output;

  size = query_keys.size();

  //printf("size: %d\n", size);

  //pan duan dang an shi fo cun zai
  status = 0;
  if(output = fopen("key_query_out1.txt", "r"))
  {
    fclose(output);
    status = 1;
  }

  if(status)
  {
    output = fopen("key_query_out2.txt", "w");
  }else
  {
    output = fopen("key_query_out1.txt", "w");
  }

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

void hash_table::remove_query(vector<int> query_keys) //3
{
  printf("  remove_query\n");

  int i, j, temp, tempOne;
  unsigned int mask;
  int key, size, status;
  int index, pointer;

  size = query_keys.size();

  printf("\tsize: %d\n", size);

  for(i=0; i<size; i++)
  {
    key = query_keys[i];

    index = key & ((1 << info[0]) - 1);
    pointer = directory[index];
    status = bucket[pointer][1];

    //printf("\tkey: %d, index: %d, pointer: %d\n", key, index, pointer);

    //debug
    /*temp = pow(2, info[0]);
    for(j=0; j<temp; j++)
    {
      printf("%d %d (%d)\n", j, directory[j], bucket[directory[j]][0]);
    }*/

    if(status == 1)
    {
      //printf("\t\tbucket has one data\n");

      if(key == bucket[pointer][2])
      {
        bucket[pointer][2] = 0;
        bucket[pointer][3] = 0;

        mask = 0;

        mask = 1u << bucket[pointer][0]-1;
        tempOne = pointer ^ mask;

        //printf("\n\t\tpointer:%d, temp: %d\n", pointer, tempOne);

        tempOne = directory[tempOne];

        if(bucket[pointer][0] == bucket[tempOne][0])
        {
          bucket[tempOne][0]--;

          temp = pow(2, info[0]);

          for(j=0; j<temp; j++)
          {
            if(directory[j] == pointer)
            {
              directory[j] = tempOne;
            }
          }

          bucket[pointer][0] = 0;
          bucket[pointer][1] = 0;
        }else
        {
          bucket[pointer][1] = 0;
        }
      }
    }else if(status == 2)
    {
      //printf("\t\tbucket has two data\n");

      if(key == bucket[pointer][2])
      {
        bucket[pointer][2] = bucket[pointer][4];
        bucket[pointer][3] = bucket[pointer][5];
        bucket[pointer][1]--;
      }else if(key == bucket[pointer][4])
      {
        bucket[pointer][4] = 0;
        bucket[pointer][5] = 0;
        bucket[pointer][1]--;
      }else
      {
        continue;
      }

      mask = 0;

      mask = 1u << bucket[pointer][0]-1;
      tempOne = pointer ^ mask;

      //printf("\n\t\tpointer:%d, temp: %d\n", pointer, tempOne);

      tempOne = directory[tempOne];

      if(bucket[pointer][0] == bucket[tempOne][0])
      {
        if(bucket[tempOne][1] < 2)
        {
          //printf("\t\t\tcan be combind\n");

          if(bucket[tempOne][1] == 1)
          {
            bucket[tempOne][4] = bucket[pointer][2];
            bucket[tempOne][5] = bucket[pointer][3];
            bucket[tempOne][1] = 2;
          }else if(bucket[tempOne][1] == 0)
          {
            bucket[tempOne][2] = bucket[pointer][2];
            bucket[tempOne][3] = bucket[pointer][3];
            bucket[tempOne][1] = 1;
          }

          bucket[tempOne][0]--;

          temp = pow(2, info[0]);

          for(j=0; j<temp; j++)
          {
            if(directory[j] == pointer)
            {
              directory[j] = tempOne;
            }
          }

          bucket[pointer][0] = 0;
          bucket[pointer][1] = 0;
        }
      }
    }else
    {
      mask = 0;

      mask = 1u << bucket[pointer][0]-1;
      tempOne = pointer ^ mask;

      //printf("\n\t\tpointer:%d, temp: %d\n", pointer, tempOne);

      tempOne = directory[tempOne];

      if(bucket[pointer][0] == bucket[tempOne][0])
      {
        bucket[tempOne][0]--;

        temp = pow(2, info[0]);

        for(j=0; j<temp; j++)
        {
          if(directory[j] == pointer)
          {
            directory[j] = tempOne;
          }
        }

        bucket[pointer][0] = 0;
      }
    }

    //pause
    //fgetc(stdin);
  }

  while(temp)
  {
    temp = check();
  }
}

int check()
{
  int i, j, temp, tempOne;
  int size, pointer, result, mask;

  result = 0;

  size = pow(info[0], 2);

  for(i=0; i<size; i++)
  {
    pointer = directory[i];

    if(bucket[pointer][1] > 0)
    {
      continue;
    }

    mask = 0;
    mask = 1u << bucket[pointer][0]-1;
    tempOne = pointer ^ mask;

    //printf("\n\t\tpointer:%d, temp: %d\n", pointer, tempOne);

    tempOne = directory[tempOne];

    if(bucket[pointer][0] == bucket[tempOne][0])
    {
      bucket[tempOne][0]--;

      temp = pow(2, info[0]);

      for(j=0; j<temp; j++)
      {
        if(directory[j] == pointer)
        {
          directory[j] = tempOne;
        }
      }

      bucket[pointer][0] = 0;

      result = 1;
    }
  }

  return result;
}

/* Free the memory that you have allocated in this program
*/
void hash_table::clear(){ //5
  printf("\t\t94\n");
}
