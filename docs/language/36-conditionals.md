## Conditionals

The following conditionals are supported in T:

1.  `if` statements

### If statements

If statements are like those you have seen in any other language, they
are composed of atleast one `if` branch:

``` d
int val = 2;
if(val == 1)
{
    // Code goes here
}
```

You can add alternative conditions using the `else if` keyword:

``` d
int val = 2;
if(val == 2)
{
    // Code goes here
}
else if(val == 3)
{
    // Code goes here
}
```

In the case the conditions are not true for any of the `if` or `else if`
branches then “default” code can be run in the `else` branch as such:

``` d
int val = 2;
if(val == 2)
{
    // Code goes here
}
else if(val == 3)
{
    // Code goes here
}
else
{
    // Code goes here
}
```
