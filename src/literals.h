#pragma once

constexpr unsigned operator "" KB(unsigned long long input)
{
    return input * 1024;
}