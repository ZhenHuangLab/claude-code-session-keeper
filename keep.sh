#!/usr/bin/env bash

# 标记当天各时段是否已执行
LAST_DATE_6=""
LAST_DATE_11=""
LAST_DATE_16=""
LAST_DATE_21=""

while true; do
  NOW=$(date +"%H%M")
  TODAY=$(date +"%Y-%m-%d")

  # 07点任务
  if (( 10#$NOW >= 700 && 10#$NOW <= 710 )) && [[ "$LAST_DATE_6" != "$TODAY" ]]; then
    claude -p "What day is it today?"
    echo "执行时间: $(date +'%Y-%m-%d %H:%M:%S') - 07点任务执行"
    LAST_DATE_6="$TODAY"
  fi

  # 12点任务
  if (( 10#$NOW >= 1200 && 10#$NOW <= 1210 )) && [[ "$LAST_DATE_11" != "$TODAY" ]]; then
    claude -p "What time is it now?"
    echo "执行时间: $(date +'%Y-%m-%d %H:%M:%S') - 12点任务执行"
    LAST_DATE_11="$TODAY"
  fi

  # 17点任务
  if (( 10#$NOW >= 1700 && 10#$NOW <= 1710 )) && [[ "$LAST_DATE_16" != "$TODAY" ]]; then
    claude -p "What's the weather like outside now?"
    echo "执行时间: $(date +'%Y-%m-%d %H:%M:%S') - 17点任务执行"
    LAST_DATE_16="$TODAY"
  fi

  # 22点任务
  if (( 10#$NOW >= 2200 && 10#$NOW <= 2210 )) && [[ "$LAST_DATE_21" != "$TODAY" ]]; then
    claude -p "What's your name?"
    echo "执行时间: $(date +'%Y-%m-%d %H:%M:%S') - 22点任务执行"
    LAST_DATE_21="$TODAY"
  fi

  sleep 30
done
